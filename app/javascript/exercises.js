function runTests() {
  let exerciseId = window.location.pathname.match(/\/exercises\/([^/]+)/)[1];
  let containerId = document.getElementById("container_id").value;
  let code = document.getElementById("iteration_code").value;

  let formData = new URLSearchParams();
  formData.append("container_id", containerId);
  formData.append("code", code);

  fetch("/exercises/" + exerciseId + "/iterations/run", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: formData.toString()
  })
  .then(response => {
    console.log(response);
  })
  .catch(err => {
    console.error(err);
  });
}