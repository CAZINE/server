$(`.input-radio-volum input`).each(function (index, element) {
    startInput(element)
    element.addEventListener("input", handleInputChange)
});

function startInput(element) {
    $("#volum_text").text(`${element.value}%`)
    $(element).css("background-size", `${(element.value - element.min) * 100 / (element.max - element.min)}% 100%`)
}
function handleInputChange(e) {
    let target = e.target
    $("#volum_text").text(`${Math.round(Number(target.value))}%`)
    $(target).css("background-size", `${(target.value - target.min) * 100 / (target.max - target.min)}% 100%`)
}

function handleVolum(element) {
    // let target = element.target
    $.post("https://radio/changeVolume", JSON.stringify({volume: element.value}));
}

function setRadioChannel(element) {
    $.post("https://radio/activeFrequency", JSON.stringify({
        radio: $(".input-radio input[type='number']").val()
    }));
}

window.addEventListener("message", function (event) {
    let data = event["data"]
    switch (data["action"]) {
        case "showMenu":
            $("#volum_text").text(`${data.volume}%`)
            $(".input-radio-volum input").val(Math.round(Number(data.volume)))
            $(".input-radio-volum input").css("background-size", `${((Number(data.volume)) - Number($(".input-radio-volum input").attr('min'))) * 100 / (Number($(".input-radio-volum input").attr("max")) - Number($(".input-radio-volum input").attr("min")))}% 100%`)
            if (data.radio) {
                $('.input-radio').fadeOut(0);
                $(".input-radio-disconnect").fadeIn(200);
            } else {
                $(".input-radio-disconnect").fadeOut(0);
                $('.input-radio').fadeIn(200);
            }
            $(".radio-interface").fadeIn();
            break;
        case "updateStatus":
            if (data.radio) {
                $('.input-radio').fadeOut(0);
                $(".input-radio-disconnect").fadeIn(200);
            } else {
                $(".input-radio-disconnect").fadeOut(0);
                $('.input-radio').fadeIn(200);
            }
            break;
        case "hideMenu":
            $(".radio-interface").fadeOut();
            break;
        case "radioTalking":
            if (data.talking) {
                let svg = `
        <div id="radio-voice-icon">
            <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" class="speaker-anim">
                <path d="M11 5L6 9H2v6h4l5 4V5z"/>
                <path class="wave" d="M19 12c0-2.21-1.79-4-4-4"/>
                <path class="wave" d="M19 12c0 2.21-1.79 4-4 4"/>
            </svg>
            <div class="radio-voice-name">${data.player || ""}</div>
        </div>
        `;
                $("#radio-toast").html(svg).fadeIn(100);
            } else {
                $("#radio-toast").fadeOut(100);
            }
            break;
    }
})

$(document).keyup(function (e) {
    if (e.keyCode == 27) {
        $(".radio-interface").fadeOut();
        $.post("https://radio/closeRadio")
    }
});

function disconnectRadio(element) {
    $.post("https://radio/deactiveFrequency");
}