function setCookie(cname, cvalue, exdays) {
  const d = new Date();
  d.setTime(d.getTime() + exdays * 24 * 60 * 60 * 1000);
  let expires = "expires=" + d.toUTCString();
  document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}
function getCookie(cname) {
  let name = cname + "=";
  let decodedCookie = decodeURIComponent(document.cookie);
  let ca = decodedCookie.split(";");
  for (let i = 0; i < ca.length; i++) {
    let c = ca[i];
    while (c.charAt(0) == " ") {
      c = c.substring(1);
    }
    if (c.indexOf(name) == 0) {
      return c.substring(name.length, c.length);
    }
  }
  return "";
}

const getUserCount = async () => {
  const myHeaders = new Headers();
  myHeaders.append("Content-Type", "application/json");

  try {
    const response = await fetch(
      "https://595io2smeg.execute-api.us-east-1.amazonaws.com/user-count",
      {
        method: "GET",
        headers: myHeaders,
        redirect: "follow",
      }
    );
    const result_1 = await response.text();
    return (userCountResponse = JSON.parse(result_1).count);
  } catch (error) {
    return console.error(error);
  }
};

const setUserCount = async () => {
  const myHeaders = new Headers();
  myHeaders.append("Content-Type", "application/json");

  try {
    const response = await fetch(
      "https://595io2smeg.execute-api.us-east-1.amazonaws.com/user-count",
      {
        method: "POST",
        headers: myHeaders,
        redirect: "follow",
      }
    );
    const result_1 = await response.text();
    return (userCountResponse = JSON.parse(result_1).count);
  } catch (error) {
    return console.error(error);
  }
};
const updateDomValue = (value) => {
  document.querySelector(
    ".userCount"
  ).innerHTML = `<b>User Count: ${value}</b>`;
};
const init = async () => {
  const userBeenHere = getCookie("user");
  let userCount = sessionStorage.getItem("userCount");
  console.log(userCount);
  if (userBeenHere) {
    if (userCount === null) {
      userCount = await getUserCount();
      sessionStorage.setItem("userCount", userCount);
    }
  } else {
    setCookie("user", "true", 365);
    userCount = await setUserCount();
  }
  updateDomValue(userCount);
};
document.addEventListener("DOMContentLoaded", function () {
  init();
});
