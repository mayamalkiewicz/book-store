// header

window.addEventListener("scroll", (e) => {
  const nav = document.querySelector(".header-container");
  if (window.pageYOffset > 0) {
    nav.classList.add("add-shadow");
  } else {
    nav.classList.remove("add-shadow");
  }
});
