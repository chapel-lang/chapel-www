(function () {
  const INDEX_URL =
    "http://localhost:52095/index.json";
    // "https://raw.githubusercontent.com/chapel-lang/mason-registry/master/index.json";

  function sourceUrl(url) {
    if (!url) return "";
    return url.replace(/^git@github\.com:/, "https://github.com/").replace(/\.git$/, "");
  }

  function authorList(authors) {
    if (!authors) return [];
    return Array.isArray(authors) ? authors : [authors];
  }

  function renderPackages(registry) {
    const names = Object.keys(registry);

    const rows = names.map((name) => {
      const versions = registry[name];
      const latest = versions[0];
      const latestVersion = `<p><em class="bold">Latest version:</em> ${latest.version}</p>`;
      let chplVersion = "";
      let versionMin = "";
      let versionMax = "";
      if (latest.chplVersion) {
        if (latest.chplVersion.includes("..")) {
          [versionMin, versionMax] = latest.chplVersion.split("..").map((v) => v.trim());
          chplVersion = `<p><em class="bold">Chapel Version Compatibility:</em> ${versionMin} to ${versionMax}</p>`;
        } else {
          versionMin = versionMax = latest.chplVersion.trim();
          chplVersion = `<p><em class="bold">Chapel Version Compatibility:</em> ${latest.chplVersion} and later</p>`;
        }
      }
      const url = sourceUrl(latest.source);
      let authors = "";
      const authorArr = authorList(latest.authors);
      if (authorArr.length === 1) {
        authors = `<p><em class="bold">Author:</em> ${authorArr[0]}</p>`;
      } else if (authorArr.length > 1) {
        authors = `<p><em class="bold">Authors:</em> ${authorArr.join(", ")}</p>`;
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
      const license = licenseText ? `<p><em class="bold">License:</em> ${licenseText}</p>` : "";

      const sourceLink = url ? `<p><a href=${url} rel="noopener" target="_blank">Source</a></p>` : "";

      const type = latest.type ? `<p><em class="bold">Type:</em> <span class="type-${latest.type}">${latest.type}</span></p>` : "";

      return `<li class="list-group-item" data-name="${name}">
        <h3>${name}</h3>
        ${latestVersion}
        ${chplVersion}
        ${authors}
        ${license}
        ${type}
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

  function applySearch(query, idx, list) {
    const items = list.querySelectorAll("li[data-name]");
    if (!query.trim()) {
      items.forEach((li) => (li.style.display = ""));
      updateVisibilityClasses(items);
      return;
    }
    let matches;
    try {
      matches = new Set(idx.search(query).map((r) => r.id));
    } catch (_) {
      matches = new Set();
    }
    items.forEach((li) => {
      li.style.display = matches.has(li.dataset.name) ? "" : "none";
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
        searchInput.addEventListener("input", function () {
          applySearch(this.value, idx, listEl);
        });
      })
      .catch(function (err) {
        errorSpan.textContent = "Could not load package list.";
      });
  });
})();

