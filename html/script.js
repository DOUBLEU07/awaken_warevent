$(function() {

    function display(bool) {
        if (bool) {
            $(".container-gangs").fadeIn(100);
            $(".container-time").fadeIn(100);

        } else {
            $(".container-gangs").fadeOut(100);
            $(".container-time").fadeOut(100);

        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true);
                $(".container-gangs").html("");
                $.each(item.gangs, function(k, v) {
                    $(".container-gangs").append('<div id="items">' +
                        '<div class="box-img">' +
                        '<img id="imgLink" src="' + v.imgLink + '">' +
                        '</div>' +
                        '<div class="box-name">' +
                        '<p id="gangs gang_' + v.jobName + '">' + v.label + '</p>' +
                        '</div>' +
                        '<div class="box-score">' +
                        '<div align="center" id="score score_' + v.jobName + ' "> (' + v.rkScore + ' Kill)</div>' +
                        '</div>' +
                        '</div>');
                });

                $(".container-gangs").show(0);
            } else {
                display(false);
            }
        } else if (item.type === "updateScore") {
            $(".container-gangs").html("");
            $.each(item.gangs, function(k, v) {
                $(".container-gangs").append('<div id="items">' +
                    '<div class="box-img">' +
                    '<img id="imgLink" src="' + v.imgLink + '">' +
                    '</div>' +
                    '<div class="box-name">' +
                    '<p class="gangs" id="gangs gang_' + v.jobName + '">' + v.label + '</p>' +
                    '</div>' +
                    '<div class="box-score">' +
                    '<div align="center" class="score" id="score score_' + v.jobName + ' "> (' + v.rkScore + ' Kill)</div>' +
                    '</div>' +
                    '</div>');
            });
        } else if (item.type === "time-update") {
            $("#time-countdown").html("TIME : " + item.time);
        } else if (item.type === "showWinner") {
            $(".container-gangs").hide(0);
            $(".container-time").hide(0);

            $(".winner-logo").attr("src", item.imgWinner);
            $(".winner-label").html(item.labelWinner);
            $(".container-winner").fadeIn(1000);

            setTimeout(() => {
                $(".container-winner").fadeOut(1000);
                $.post('http://awaken_warevent/clear_ui', JSON.stringify({})); 
                return
            }, 5000);
        }
    })
});