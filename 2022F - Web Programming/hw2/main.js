const participants_pool = new Map([
    ["id-0", {name: "你", portrait_url: 'images/portrait/portrait-0.png', online: true}],
    ["id-1", {name: "李彥儒", portrait_url: 'images/portrait/portrait-1.png', online: true}],
    ["id-2", {name: "陳孟宏", portrait_url: 'images/portrait/portrait-2.png', online: true}],
    ["id-3", {name: "yl h", portrait_url: 'images/portrait/portrait-3.png', online: true}],
    ["id-4", {name: "劉慕德/Joshua Lau", portrait_url: 'images/portrait/portrait-4.png', online: true}],
    ["id-5", {name: "童子瑜", portrait_url: 'images/portrait/portrait-5.png', online: true}],
    ["id-6", {name: "新同學6", portrait_url: 'images/portrait/portrait-6.png', online: false}],
    ["id-7", {name: "新同學7", portrait_url: 'images/portrait/portrait-7.png', online: false}],
    ["id-8", {name: "新同學8", portrait_url: 'images/portrait/portrait-8.png', online: false}],
    ["id-9", {name: "新同學9", portrait_url: 'images/portrait/portrait-9.png', online: false}],
    ["id-10", {name: "新同學10", portrait_url: 'images/portrait/portrait-10.png', online: false}],
    ["id-11", {name: "新同學11", portrait_url: 'images/portrait/portrait-11.png', online: false}],
    ["id-12", {name: "新同學12", portrait_url: 'images/portrait/portrait-12.png', online: false}],
    ["id-13", {name: "新同學13", portrait_url: 'images/portrait/portrait-13.png', online: false}],
    ["id-14", {name: "新同學14", portrait_url: 'images/portrait/portrait-14.png', online: false}]
])

var onlineNumber = 6;
var isMainPanelShowing = true;
const maxOnlineNumber = 15;

function clickXHandler(e) {
    var participantBlock = e.target.parentElement;
    var id = participantBlock.getAttribute("id");
    // participants_pool set it online: false
    console.log(id);
    if (participantBlock.parentElement.matches(".meet__main-participant-panel")) {
        mainPanelCollapse();
    }
    participantBlock.remove();
    // [todo] set online: false
    participants_pool.get(id).online = false;
    if (onlineNumber == maxOnlineNumber) {
        document.querySelector(".meet__add-msg").textContent = "Add participants."
    }
    onlineNumber -= 1;
    updateParticipantInfoSize();
}

const mainPanel = document.querySelector(".meet__main-participant-panel");
const otherPanel = document.querySelector(".meet__other-participant-panel");
const stylesheet = document.styleSheets[0];

function clickPinHandler(e) {
    var participantBlock = e.target.parentElement;
    var panel = participantBlock.parentElement;

    if (panel.matches(".meet__main-participant-panel")) { // if panel = main-panel
        otherPanel.appendChild(participantBlock); // append the pinned one to other-panel
        participantBlock.querySelector(".pin_icon").style.display = "none";
        mainPanelCollapse();
    }
    else { // else (panel = other-panel)
        if (mainPanel.childElementCount > 0) { // [todo] hasChildNodes not working
            console.log("main panel has items");
            mainPanel.firstElementChild.querySelector(".pin_icon").style.display = "none";
            otherPanel.appendChild(mainPanel.firstElementChild);
            mainPanel.appendChild(participantBlock);
            participantBlock.querySelector(".pin_icon").style.display = "block";
        }
        else {
            mainPanel.appendChild(participantBlock);
            participantBlock.querySelector(".pin_icon").style.display = "block";
            mainPanelShow();
        }
    }
    // updateParticipantInfoSize();
}

function clickAddHandler(e) {
    for (const [key, value] of participants_pool){ // loop participants_pool,
        if (value.online == false) { // for the first one not online:
            otherPanel.appendChild(createElement(key)); // createElement using its info,
                                                        // and append it to other-panel
            onlineNumber += 1;
            updateParticipantInfoSize();
            return;
        }
    }
    e.target.firstElementChild.textContent = "No more participants. failed to add.";
}

function createElement(id) {
    // use id to get info from participants_pool, create an element
    participants_pool.get(id).online = true;
    newParticipantBlock = document.createElement('div');
    newParticipantBlock.classList.add("meet__participant-info");
    newParticipantBlock.id = id;
    newParticipantBlock.innerHTML = `
        <div class="pin_icon"></div>
        <div class="meet__participant-name"> ${participants_pool.get(id).name} </div>
        <div class="meet__participant-portrait"  style="background-image: url(${participants_pool.get(id).portrait_url})"> </div>
        <div id="mute_icon"></div>
        <div id="x_icon" onclick="clickXHandler(event)"> </div>
        <div class="meet__participant-more-options" onclick="clickPinHandler(event)"></div>
    `;

    return newParticipantBlock;
}

const timeText = document.querySelector(".meet__time");
function updateTime() {
    var time = new Date().toLocaleString().split(" ")[1].split(":");
    timeText.textContent = `${time[0]}:${time[1]}`;
    setTimeout("updateTime()", 1000);
}

function mainPanelCollapse() {
    mainPanel.style.display = "none";
    isMainPanelShowing = false;
    updateParticipantInfoSize();
}

function mainPanelShow() {
    mainPanel.style.display = "block";
    isMainPanelShowing = true;
    updateParticipantInfoSize();
}

function updateParticipantInfoSize() {
    // var i;
    // for(i = 0; i < stylesheet.cssRules.length; i++) {
    //     if(stylesheet.cssRules[i].selectorText === '.meet__other-participant-panel .meet__participant-info') break;
    // }
    var participantInfos = Array.from(otherPanel.querySelectorAll(".meet__participant-info"));
    console.log(participantInfos);

    if (isMainPanelShowing) {
        if (onlineNumber == 1) {
            mainPanel.style.minWidth = "100%";
        }
        else {
            participantInfos.forEach((e) => {
                e.style.minWidth = "170px";
                e.style.maxWidth = "250px";
                e.style.minHeight = "150px";
                e.style.maxHeight = "300px";
                e.style.width = "auto";
                e.style.height = "auto";
            })
            mainPanel.style.minWidth = "70%";
        }
    }
    else {
        if (onlineNumber <= 1) {
            participantInfos.forEach((e) => {
                e.style.minWidth = "98%";
                e.style.maxWidth = "auto";
                e.style.minHeight = "96%";
                e.style.maxHeight = "auto";
                e.style.width = "auto";
                e.style.height = "auto";
            })
        }
        else if (onlineNumber <= 6) {
            participantInfos.forEach((e) => {
                e.style.minWidth = "25%";
                e.style.maxWidth = "36%";
                e.style.minHeight = "auto";
                e.style.maxHeight = "40%";
                e.style.width = "auto";
                e.style.height = "20vw";
            })
        }
        else if (onlineNumber <= 12){
            participantInfos.forEach((e) => {
                e.style.minWidth = "20%";
                e.style.maxWidth = "30%";
                e.style.minHeight = "auto";
                e.style.maxHeight = "30%";
                e.style.width = "auto";
                e.style.height = "16vw";
            })
        }
        else {
            participantInfos.forEach((e) => {
                e.style.minWidth = "16%";
                e.style.maxWidth = "20%";
                e.style.minHeight = "auto";
                e.style.maxHeight = "25%";
                e.style.width = "auto";
                e.style.height = "10vw";
            })
        }
    }
}



    // function updateParticipantInfoSize() {
    //     var i;
    //     for(i = 0; i < stylesheet.cssRules.length; i++) {
    //         if(stylesheet.cssRules[i].selectorText === '.meet__other-participant-panel .meet__participant-info') break;
    //     }

    //     if (isMainPanelShowing) {
    //         if (onlineNumber == 1) {
    //             mainPanel.style.minWidth = "100%";
    //         }
    //         else {
    //             stylesheet.cssRules[i].style.setProperty("min-width", "170px"); // 1 * 1
    //             stylesheet.cssRules[i].style.setProperty("max-width", "250px");
    //             stylesheet.cssRules[i].style.setProperty("min-height", "150px");
    //             stylesheet.cssRules[i].style.setProperty("max-height", "300px");
    //             stylesheet.cssRules[i].style.setProperty("height", "auto");
    //             stylesheet.cssRules[i].style.setProperty("width", "auto");
    //             mainPanel.style.minWidth = "70%";
    //         }
    //     }
    //     else {
    //         if (onlineNumber <= 1) {
    //             stylesheet.cssRules[i].style.setProperty("min-width", "98%"); // 1 * 1
    //             stylesheet.cssRules[i].style.setProperty("max-width", "auto");
    //             stylesheet.cssRules[i].style.setProperty("min-height", "96%");
    //             stylesheet.cssRules[i].style.setProperty("max-height", "auto");
    //         }
    //         else if (onlineNumber <= 6) {
    //             stylesheet.cssRules[i].style.setProperty("min-width", "25%"); // 3 * 2
    //             stylesheet.cssRules[i].style.setProperty("max-width", "36%");
    //             stylesheet.cssRules[i].style.setProperty("min-height", "auto");
    //             stylesheet.cssRules[i].style.setProperty("max-height", "40%");
    //             stylesheet.cssRules[i].style.setProperty("height", "20vw");
    //         }
    //         else if (onlineNumber <= 12){
    //             stylesheet.cssRules[i].style.setProperty("min-width", "20%"); // 4 * 3
    //             stylesheet.cssRules[i].style.setProperty("max-width", "30%");
    //             stylesheet.cssRules[i].style.setProperty("min-height", "auto");
    //             stylesheet.cssRules[i].style.setProperty("max-height", "30%");
    //             stylesheet.cssRules[i].style.setProperty("height", "16vw");
    //         }
    //         else {
    //             stylesheet.cssRules[i].style.setProperty("min-width", "16%"); // 5 * 3
    //             stylesheet.cssRules[i].style.setProperty("max-width", "20%");
    //             stylesheet.cssRules[i].style.setProperty("min-height", "auto");
    //             stylesheet.cssRules[i].style.setProperty("max-height", "30%");
    //             stylesheet.cssRules[i].style.setProperty("height", "10vw");
    //         }
    //     }
    // }
