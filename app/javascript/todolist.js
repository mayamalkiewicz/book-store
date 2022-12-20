// to-do list JS

const btn = document.getElementById("btn");
const txt = document.getElementById("txt");
const ul = document.getElementById("ul-of-tasks");
const inputUnchecked = document.getElementsByClassName("chceck-box");
const inputChecked = document.getElementsByClassName("checkedChceckBox");
const liNotDoneTask = document.getElementById("task"); 
const liDoneTask = document.getElementById("taskDone");

// Taking a content of a new task by input.
function addTask() {
    let newLi = document.createElement("li"); //add li
    let delBtn = document.createElement("button"); //add delete button to the new task
    delBtn.className = "del-btn";
    delBtn.innerHTML = "X";

    //add checkbox to the new task
    let chceckBoxItem = document.createElement("input");
    chceckBoxItem.className = "chceck-box";
    chceckBoxItem.type = "checkbox"

    //add a conditions of adding. If true, create elements.
        if (txt.value === "") {
            alert("Add a task.")
        } else {
        newLi.appendChild(chceckBoxItem); //add checkbox
        ul.appendChild(newLi); //add new <li>
        newLi.innerHTML += txt.value; //add task text inside the  <li>
        newLi.appendChild(delBtn); //add delete button
        txt.value = ""; // remove added text from input box
        }
    //run delete button
    delBtn.addEventListener("click", function(e){
    e.target.parentNode.remove();
    })
}

// Adding a task to a list.
btn.addEventListener("click", addTask);

// Delete one element from list.
function registerClickHandler (event) {

    const delBtn = event.target;
    
    delBtn.parentNode.parentNode.removeChild(delBtn.parentNode);
} 

const deleteBtn = document.querySelectorAll(".del-btn");

for (let i = 0; i < deleteBtn.length; i++) {
    deleteBtn[i].addEventListener("click", registerClickHandler, false)
};

// Removing everything from list.
function removeAll(){
    document.getElementById("ul-of-tasks").innerHTML = "";
}