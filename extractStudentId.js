var studentId = JSON.parse($("#IntercomSettingsScriptTag").text().match(/{.*?}/)[0]).user_id;
var command_block = $($("pre.highlight.shell code").get(0));
var command = command_block.html();
command = command.replace("&gt;1234&lt;", studentId);
command_block.html(command);