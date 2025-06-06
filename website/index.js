const myHeaders = new Headers();
myHeaders.append("Content-Type", "application/json");

const raw = JSON.stringify({});

const requestOptions = {
  method: "GET",
  headers: myHeaders,
  redirect: "follow"
};

fetch("https://b2j38s5vqk.execute-api.us-east-1.amazonaws.com/visits", requestOptions)
  .then((response) => response.text())
  .then((result) => document.querySelector('.userCount').innerHTML = `<b>User Count:</b> ${JSON.parse(result).count}`)
  .catch((error) => console.error(error));