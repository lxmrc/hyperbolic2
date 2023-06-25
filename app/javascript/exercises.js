function runTests() {
  let exerciseId = window.location.pathname.match(/\/exercises\/([^/]+)/)[1];
  let containerToken = document.getElementById("container_token").value;
  let code = document.getElementById("iteration_code").value;

  let formData = new URLSearchParams();
  formData.append("token", containerToken);
  formData.append("code", code);

  const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  fetch("/exercises/" + exerciseId + "/iterations/run", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "X-CSRF-Token": csrfToken
    },
    body: formData.toString()
  })
  .then(response => response.json())
  .then(response => {
    console.log(response);

    let resultsTable = document.getElementById("test-results");
    resultsTable.innerHTML = '';

    if(response["success"]) {
      response["results"].forEach(item => {
        const li = document.createElement('li');
        li.className = `list-group-item ${item.passed ? 'list-group-item-success' : 'list-group-item-danger'}`;
        li.textContent = item.name;
        resultsTable.appendChild(li);
      });
    } else {
      const li = document.createElement('li');
      li.className = `list-group-item list-group-item-secondary`;
      li.textContent = `Something went wrong:`

      const pre = document.createElement("pre");
      pre.classList.add("p-2")
      pre.classList.add("border")

      const code = document.createElement("code");
      code.textContent = response["errors"].join("\n");

      pre.appendChild(code);
      li.appendChild(pre);

      resultsTable.appendChild(li);
    }

  })
  .catch(err => {
    console.error(err);
  });
}

window.addEventListener("keydown", function (event) {
    if (event.ctrlKey && event.keyCode === 13) {
      runTests();
    }
});
