var showingContactFormButton = false;
var rootElement = document.querySelector('body');
var targetNode = document.body;
var config = { attributes: true, childList: true, subtree: true };
var buttonContent = document.createElement("span");
buttonContent.innerHTML = "Contact Us";
var contactFormButton = document.createElement("button");
contactFormButton.classList.add(
    "dialogButton",
    "dialog-button-0",
    "uiButton--default",
    "uiButton",
    "embeddedServiceSidebarButton"
);
contactFormButton.type = "button";
var baseurl = 'https://' + window.location.hostname + '/';
var pathName = window.location.pathname;
console.log('pathName');
console.log(pathName);

var langLocale = '';
var i = 0;

var langLocales = [
    'en_DE',
    'fr_DE',
    'de_DE',
    'de_GB',
    'en_GB',
    'fr_GB'
];
while (i < langLocales.length) {
    var ll = langLocales[i];
    console.log(ll);
    console.log(pathName.indexOf(ll));
    if (pathName.indexOf(ll) >= 0) {
        langLocale = ll + '/';
        break;
    }
    i++;
}
console.log(langLocale);

var page = baseurl.indexOf('visualforce') >= 0 ? 'apex/' : pathName.indexOf('horizon-us') >= 0 ? 's/horizon-us/' : pathName.indexOf('tower-us') >= 0 ? 's/tower-us/' : pathName.indexOf('horizon-eu') >= 0 ? 's/horizon-eu/' : '';
var url = baseurl + page + langLocale + 'contact';
console.log('url');
console.log(url);
contactFormButton.onclick = () => window.open(url);
contactFormButton.appendChild(buttonContent);

var callback = function(mutationsList, observer) {
    setTimeout(function() {
        dialogButtonContainer = document.querySelector('.dialogButtonContainer');
        let dialogTextTitle = document.querySelector('#dialogTextTitle');
        if (dialogTextTitle != null && dialogTextTitle.innerHTML == 'No agents are available.' && dialogButtonContainer != null) {
            let newChatButton = dialogButtonContainer.querySelector('button.dialogButton.uiButton.embeddedServiceSidebarButton');
            dialogButtonContainer.style.visibility = 'hidden';
            newChatButton.remove();
            observer.disconnect();
            dialogButtonContainer.insertBefore(contactFormButton);
            dialogButtonContainer.style.visibility = '';
        }
    }, 10);
};
const observer = new MutationObserver(callback);
rootElement.addEventListener('click', function(event) {
    let start = document.querySelector('.startButton.uiButton--default.uiButton.embeddedServiceSidebarButton');
    let targetElement = event.target;
    let parentElement = event.target.parentElement;
    let grandParent = parentElement.parentElement;
    let targets = [
        targetElement, parentElement, grandParent
    ];
    const dialogButtonContainer = null;
    if (targets.indexOf(start) >= 0) {
        targetNode = document.querySelector('.dockableContainer.showDockableContainer');
        observer.observe(targetNode, config);
    }
}, true);