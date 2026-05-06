(function () {
  const INDEX_URL =
    "https://raw.githubusercontent.com/chapel-lang/mason-registry/master/index.json";

  function sourceUrl(url) {
    if (!url) return "";
    if (url.startsWith("git@github.com:")) {
      return "https://github.com/" + url.slice("git@github.com:".length).replace(/\.git$/, "");
    }
    if (url.startsWith("https://github.com/")) return url;
    return "";
  }

  function authorList(authors) {
    if (!authors) return [];
    return Array.isArray(authors) ? authors : [authors];
  }

  function timeAgo(isoString) {
    const rtf = new Intl.RelativeTimeFormat("en", { numeric: "auto" });
    const seconds = Math.min((new Date(isoString) - Date.now()) / 1000, 0);
    const intervals = [
      [31536000, "year"], [2592000, "month"], [86400, "day"],
      [3600, "hour"],     [60, "minute"],
    ];
    for (const [secs, unit] of intervals) {
      if (-seconds >= secs)
        return rtf.format(Math.round(seconds / secs), unit);
    }
    return rtf.format(Math.round(seconds), "second");
  }

  function renderPackages(registry) {
    const names = Object.keys(registry);

    const rows = names.map((name) => {
      const versions = registry[name];
      const latest = versions[0];
      const latestVersion = `<p><strong>Latest version:</strong> ${latest.version}</p>`;
      let chplVersion = "";
      let versionMin = "";
      let versionMax = "";
      let chplDataAttrs = "";
      if (latest.chplVersion) {
        if (latest.chplVersion.includes("..")) {
          [versionMin, versionMax] = latest.chplVersion.split("..").map((v) => v.trim());
          chplVersion = `<p><strong>Chapel Version Compatibility:</strong> ${versionMin} to ${versionMax}</p>`;
          chplDataAttrs = `data-chpl-min="${versionMin}" data-chpl-max="${versionMax}"`;
        } else {
          versionMin = latest.chplVersion.trim();
          chplVersion = `<p><strong>Chapel Version Compatibility:</strong> ${latest.chplVersion} and later</p>`;
          chplDataAttrs = `data-chpl-min="${versionMin}"`;
        }
      }
      let authors = "";
      const authorArr = authorList(latest.authors);
      if (authorArr.length === 1) {
        authors = `<p><strong>Author:</strong> ${authorArr[0]}</p>`;
      } else if (authorArr.length > 1) {
        authors = `<p><strong>Authors:</strong> ${authorArr.join(", ")}</p>`;
      }
      var licenseText = null;
      if (latest.license && latest.license !== "None") {
        if (latest.copyrightYear) {
          licenseText = `${latest.license} (Copyright ${latest.copyrightYear})`;
        } else {
          licenseText = latest.license;
        }
      } else if (latest.copyrightYear) {
        licenseText = `Copyright ${latest.copyrightYear}`;
      }
      const license = licenseText ? `<p><strong>License:</strong> ${licenseText}</p>` : "";

      const url = sourceUrl(latest.source);
      const sourceLink = url ? `<p><a href=${url} rel="noopener" target="_blank">Source</a></p>` : "";

      const type = latest.type ? `<p><strong>Type:</strong> <span class="type-${latest.type}">${latest.type}</span></p>` : "";

      const updated = latest.createdDate ? `<p><strong>Last updated:</strong> ${timeAgo(latest.createdDate)}</p>` : "";

      return `<li class="list-group-item" data-name="${name}" ${chplDataAttrs}>
        <h3>${name}</h3>
        ${latestVersion}
        ${chplVersion}
        ${authors}
        ${license}
        ${type}
        ${updated}
        ${sourceLink}
      </li>`;
    });

    return `<ul id="mason-packages-list" class="list-group">
      ${rows.join("\n")}
    </ul>`;
  }

  function buildSearchIndex(registry) {
    const ms = new MiniSearch({
      fields: ["name", "authors", "license", "chplVersion"],
      storeFields: ["name"],
      searchOptions: {
        prefix: true,
        fuzzy: 0.15,
        boost: { name: 10 },
      },
    });
    ms.addAll(
      Object.keys(registry).map((name) => {
        const latest = registry[name][0];
        return {
          id: name,
          name,
          authors: authorList(latest.authors).join(" "),
          license: latest.license || "",
          chplVersion: latest.chplVersion || "",
        };
      })
    );
    return ms;
  }

  function updateVisibilityClasses(items) {
    let first = null, last = null;
    items.forEach((li) => {
      li.classList.remove("is-first-visible", "is-last-visible");
      if (li.style.display !== "none") {
        if (!first) first = li;
        last = li;
      }
    });
    if (first) first.classList.add("is-first-visible");
    if (last) last.classList.add("is-last-visible");
  }

  function versionLt(a, bParsed) {
    const aParsed = a.split(".").map(Number);
    for (let i = 0; i < Math.max(aParsed.length, bParsed.length); i++) {
      const ai = aParsed[i] || 0, bi = bParsed[i] || 0;
      if (ai < bi) return true;
      if (ai > bi) return false;
    }
    return false;
  }

  const VERSION_2_0_0 = [2, 0, 0];

  function applyFilters(query, vtwoOnly, idx, listEl) {
    const items = listEl.querySelectorAll("li[data-name]");
    let searchMatches = null;
    if (query.trim()) {
      try {
        searchMatches = new Set(idx.search(query).map((r) => r.id));
      } catch (_) {
        searchMatches = new Set();
      }
    }
    items.forEach((li) => {
      const passSearch = !searchMatches || searchMatches.has(li.dataset.name);
      const max = li.dataset.chplMax;
      const passVtwo = !vtwoOnly || !max || !versionLt(max, VERSION_2_0_0);
      li.style.display = passSearch && passVtwo ? "" : "none";
    });
    updateVisibilityClasses(items);
  }

  document.addEventListener("DOMContentLoaded", function () {
    const root = document.getElementById("mason-packages-root");
    if (!root) return;

    const errorSpan = document.getElementById("mason-error");

    errorSpan.textContent = "Loading packages…";

    fetch(INDEX_URL)
      .then(function (response) {
        if (!response.ok) {
          throw new Error("Failed to fetch registry index");
        }
        return response.json();
      })
      .then(function (registry) {
        errorSpan.textContent = "";
        const idx = buildSearchIndex(registry);

        const searchInput = document.getElementById("mason-packages-search");

        const listWrapper = document.createElement("div");
        listWrapper.innerHTML = renderPackages(registry);
        root.appendChild(listWrapper);

        const listEl = listWrapper.querySelector("#mason-packages-list");
        updateVisibilityClasses(listEl.querySelectorAll("li[data-name]"));

        const vtwoToggle = document.getElementById("mason-filter-vtwo");

        function runFilters() {
          applyFilters(searchInput.value, vtwoToggle.checked, idx, listEl);
        }

        searchInput.addEventListener("input", runFilters);
        vtwoToggle.addEventListener("change", runFilters);
        runFilters();
      })
      .catch(function (err) {
        errorSpan.textContent = "Could not load package list.";
      });
  });
})();
