// to-do list JS


const btn = document.getElementById("btn"); //button
const txt = document.getElementById("txt"); //input
const ul = document.getElementById("ul-of-tasks"); //list
const inputUnchecked = document.getElementsByClassName("chceckBox"); // input unchecked chceckbox
const inputChecked = document.getElementsByClassName("checkedChceckBox"); // input checked chceckbox
const liNotDoneTask = document.getElementById("task"); // li task NOT done
const liDoneTask = document.getElementById("taskDone");  //li task done

// Taking a content of a new task by input.
function addTask() {
    //add li
    let newLi = document.createElement("li");
    //add delete button to the new task
    let delBtn = document.createElement("button");
    delBtn.className = "delBtn";
    delBtn.innerHTML = "X";

    //add checkbox to the new task
    let chceckBoxItem = document.createElement("input");
    chceckBoxItem.className = "chceckBox";
    chceckBoxItem.type = "checkbox"

    //add a conditions of adding. If ok, create elements.
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

const deleteBtn = document.querySelectorAll(".delBtn");

for (let i = 0; i < deleteBtn.length; i++) {
    deleteBtn[i].addEventListener("click", registerClickHandler, false)
};

// Removing everything from list.
function removeAll(){
    document.getElementById("ul-of-tasks").innerHTML = "";
}