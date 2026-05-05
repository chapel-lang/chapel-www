(function () {
  const INDEX_URL =
    "http://localhost:52095/index.json";
    // "https://raw.githubusercontent.com/chapel-lang/mason-registry/master/index.json";

  function sourceUrl(url) {
    if (!url) return "";
    return url.replace(/^git@github\.com:/, "https://github.com/").replace(/\.git$/, "");
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
      if (latest.authors) {
        if (latest.authors.length === 1) {
          authors = `<p><em class="bold">Author:</em> ${latest.authors[0]}</p>`;
        } else {
          authors = `<p><em class="bold">Authors:</em> ${latest.authors.join(", ")}</p>`;
        }
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

      return `<li>
        <h3>${name}</h3>
        ${latestVersion}
        ${chplVersion}
        ${authors}
        ${license}
        ${type}
        ${sourceLink}
      </li>`;
    });

    return `<ul id="mason-packages-table">
      ${rows.join("\n")}
    </ul>`;
  }

  document.addEventListener("DOMContentLoaded", function () {
    const root = document.getElementById("mason-packages-root");
    if (!root) return;

    root.textContent = "Loading packages…";

    fetch(INDEX_URL)
      .then(function (response) {
        if (!response.ok) {
          throw new Error("Failed to fetch registry index: " + response.status);
        }
        return response.json();
      })
      .then(function (registry) {
        root.innerHTML = renderPackages(registry);
      })
      .catch(function (err) {
        root.textContent = "Could not load package list: " + err.message;
      });
  });
})();
