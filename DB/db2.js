(function addDB() {
    var fscommand = player_DoFSCommand;

	function showMessage(msgType, options) {
		if (window.jBox) {
			var box = new jBox(msgType, options);
			box.open();
			return box;
		}
		else
			alert(options.content);
		return null;
	}

	function notice(options) {
		return showMessage('Notice', options);
	}

	function message(options) {
		return showMessage('Modal', options);
	}

	if (!window.qmmsg) {
		window.qmmsg={
			waiting: "Waiting for connection",
			saved: "Results have been saved. Please see the teacher for your percentage grade.",
			failed: "Results have NOT been saved. Please see the teacher for your percentage grade."
		}
	}

    // show connection onload using $() until connection is established
	$(function() {
		window.conn = notice({content: qmmsg.waiting, color: 'red', ignoreDelay: true});
	});

    // redefine DoFSCommand (FlashScript)
    // to make DB storage possible
    window.player_DoFSCommand = function(command, args)
    {
        args = String(args);
        command = String(command);
        var arrArgs = args.split(g_strDelim);
		if (window.console) {
				console.log(command);
				console.log(arrArgs);
		}
        switch(command)
        {
			case "CC_StoreQuestionResult":
				if (window.jBox) conn.close({ignoreDelay: true});
				/*
				var q = arrArgs[0];
				var qNr = arrArgs[2];
				var t = arrArgs[1];
				var a = arrArgs[6];
				var data = {time: t, question: q, answer: a};
				if (window.jStorage) {
					if (!$.jStorage.get(qNr)) {
						$.jStorage.set(qNr, data);
					}
				}
				*/
                // store in results for final submit
                fscommand(command, args);
				// store in database, only useful for submit-one quiz
				var oQuestionResult = new QuestionResult(parseFloat(arrArgs[0]), arrArgs[1], arrArgs[2], arrArgs[3], arrArgs[4] ,arrArgs[5], arrArgs[6], arrArgs[7], arrArgs[8], arrArgs[9]);
                $.ajax(
                    	{
                    		url: "/DB/log_question.asp",
                    		data: {user: g_oQuizResults, response: oQuestionResult},
                    		datatype: "xml",
                    		type: 'GET',
                    		async:true
    			});

				break;
			case "CC_SetDelim":
                fscommand(command, args);
				if (window.jBox) conn.close({ignoreDelay: true});
				break;
			case "CC_StoreQuizResult":
            		if (args!=='') {
                		fscommand(command, args);
                    	g_oQuizResults.oOptions.strName = "";
                    }
                    $.ajax(
                    	{
                    		url: "/DB/db.asp",
                    		data: {quiz: g_oQuizResults, responses: g_arrResults},
                    		datatype: "xml",
                    		type: 'POST',
                    		async:false
					})
					.done(function() {
						if (typeof g_oQuizResults.sent == "undefined") {
							message({content: qmmsg.saved, theme: 'ModalBorder'});
							$('#fc').hide();
							g_oQuizResults.sent = true;
							}
						else {
							message({content: qmmsg.duplicate, theme: 'ModalBorder'});
							$('#fc').hide();
						}
						})
					.fail(function() {
							message({content: qmmsg.failed, theme: 'ModalBorder'});
						});
					break;
            default:
                fscommand(command, args);
        }
    };
    window.DoOnClose = function() {
    	window.player_DoFSCommand("CC_StoreQuizResult", [true,true,true,false,g_oQuizResults.strResult,''].join(g_strDelim));
    	return "sending data";
    };
}
)()