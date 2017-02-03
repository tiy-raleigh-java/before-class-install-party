function getIntercomData(){
    return JSON.parse($("#IntercomSettingsScriptTag").text().match(/{.*?}/)[0]);
}

alert(getIntercomData().user_id);