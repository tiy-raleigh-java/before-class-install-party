var studentId = JSON.parse($("#IntercomSettingsScriptTag").text().match(/{.*?}/)[0]).user_id;
var command_block = $($("pre.highlight.shell code span:first-child").get(0));
command_block.html('curl -s https://raw.githubusercontent.com/tiy-raleigh-java/before-class-install-party/master/install_everything.sh | bash -s ' + studentId + ' "Doug Hughes"');