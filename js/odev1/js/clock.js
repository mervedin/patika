var days = ["Pazar", "Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi"];

// get user name
let userName = prompt("Adınız nedir?");
// display user name 
let nameDOM = document.querySelector("#myName")
nameDOM.innerHTML = `${userName[0].toUpperCase()}${userName.slice(1).toLowerCase()}`;

// display time
let clockDOM = document.querySelector("#myClock");
const addZero = (num) => {return num < 10 ? `0${num}`: num};
function displayTime(){
    let today = new Date;
    clockDOM.innerHTML = `${addZero(today.getHours())}:${addZero(today.getMinutes())}:${addZero(today.getSeconds())} ${days[today.getDay()]}`;
}

setInterval(displayTime, 10)