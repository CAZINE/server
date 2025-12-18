$(document).ready(function () {
    var documentWidth = document.documentElement.clientWidth;
    var documentHeight = document.documentElement.clientHeight;
    var cursor = $('#cursorPointer');
    var cursorX = documentWidth / 2;
    var cursorY = documentHeight / 2;

    function triggerClick(x, y) {
        var element = $(document.elementFromPoint(x, y));
        element.focus().click();
        return true;
    }

    window.addEventListener('message', function (event) {
        $("#data-legend-hair").attr("data-legend", event.data.maxHair);
        $("#hairmodel").attr("max", event.data.maxHair);

        document.getElementById("lipstick").value = event.data.lipstick;
        document.getElementById("lipstickcolor").value = event.data.lipstickcolor;
        document.getElementById("hairmodel").value = event.data.hairmodel;
        document.getElementById("hairfirstcolor").value = event.data.hairfirstcolor;
        document.getElementById("hairsecondarycolor").value = event.data.hairsecondarycolor;
        document.getElementById("blush").value = event.data.blush;
        document.getElementById("blushcolor").value = event.data.blushcolor;
        document.getElementById("makeup").value = event.data.makeup;
        document.getElementById("eyebrows").value = event.data.eyebrows;
        document.getElementById("eyebrowscolor").value = event.data.eyebrowscolor;
        document.getElementById("beard").value = event.data.beard;
        document.getElementById("beardcolor").value = event.data.beardcolor;
        document.getElementById("chest").value = event.data.chest;
        document.getElementById("chestcolor").value = event.data.chestcolor;

        if (event.data.openBarbershop == true) {
            $(".openBarbershop").css("display", "block");

            $('.input .label-value').each(function () {
                var max = $(this).attr('data-legend'), val = $(this).next().find('input').val();
                $(this).parent().find('.label-value').text(val + ' / ' + max);
            });
        }

        if (event.data.openBarbershop == false) {
            $(".openBarbershop").css("display", "none");
        }

        if (event.data.type == "click") {
            triggerClick(cursorX - 1, cursorY - 1);
        }
    });

    $('input').on('input', function () {
        $.post('http://barbershop/updateSkin', JSON.stringify({
            value: false,
            father: $('.father').val(),
            mother: $('.mother').val(),
            eyescolor: $('.eyescolor').val(),
            eyebrowsheight: $('.eyebrowsheight').val(),
            eyebrowsmargin: $('.eyebrowsmargin').val(),
            nose: $('.nose').val(),
            noseheight: $('.noseheight').val(),
            nosemargin: $('.nosemargin').val(),
            nosebridge: $('.nosebridge').val(),
            nosetip: $('.nosetip').val(),
            noseshift: $('.noseshift').val(),
            cheekboneheight: $('.cheekboneheight').val(),
            cheekbonemargin: $('.cheekbonemargin').val(),
            cheekbone: $('.cheekbone').val(),
            lips: $('.lips').val(),
            lipsmargin: $('.lipsmargin').val(),
            lipsheight: $('.lipsheight').val(),
            chinlength: $('.chinlength').val(),
            chinposition: $('.chinposition').val(),
            chinwidth: $('.chinwidth').val(),
            chinshape: $('.chinshape').val(),
            neckwidth: $('.neckwidth').val(),
            hairmodel: $('.hairmodel').val(),
            hairfirstcolor: $('.hairfirstcolor').val(),
            hairsecondarycolor: $('.hairsecondarycolor').val(),
            eyebrows: $('.eyebrows').val(),
            eyebrowscolor: $('.eyebrowscolor').val(),
            beard: $('.beard').val(),
            beardcolor: $('.beardcolor').val(),
            chest: $('.chest').val(),
            chestcolor: $('.chestcolor').val(),
            blush: $('.blush').val(),
            blushcolor: $('.blushcolor').val(),
            lipstick: $('.lipstick').val(),
            lipstickcolor: $('.lipstickcolor').val(),
            blemishes: $('.blemishes').val(),
            ageing: $('.ageing').val(),
            complexion: $('.complexion').val(),
            sundamage: $('.sundamage').val(),
            freckles: $('.freckles').val(),
            makeup: $('.makeup').val(),
            shapemix: $('.shapemix').val(),
            skincolor: $('.skincolor').val(),
            makeupintensity: $('.makeupintensity').val(),
            makeupcolor: $('.makeupcolor').val(),
            lipstickintensity: $('.lipstickintensity').val(),
            eyebrowintensity: $('.eyebrowintensity').val(),
            beardintentisy: $('.beardintentisy').val(),
            blushintentisy: $('.blushintentisy').val(),
        }));
    });

    $('.arrow').on('click', function (e) {
        e.preventDefault();

        $.post('http://barbershop/updateSkin', JSON.stringify({
            value: false,
            father: $('.father').val(),
            mother: $('.mother').val(),
            eyescolor: $('.eyescolor').val(),
            eyebrowsheight: $('.eyebrowsheight').val(),
            eyebrowsmargin: $('.eyebrowsmargin').val(),
            nose: $('.nose').val(),
            noseheight: $('.noseheight').val(),
            nosemargin: $('.nosemargin').val(),
            nosebridge: $('.nosebridge').val(),
            nosetip: $('.nosetip').val(),
            noseshift: $('.noseshift').val(),
            cheekboneheight: $('.cheekboneheight').val(),
            cheekbonemargin: $('.cheekbonemargin').val(),
            cheekbone: $('.cheekbone').val(),
            lips: $('.lips').val(),
            lipsmargin: $('.lipsmargin').val(),
            lipsheight: $('.lipsheight').val(),
            chinlength: $('.chinlength').val(),
            chinposition: $('.chinposition').val(),
            chinwidth: $('.chinwidth').val(),
            chinshape: $('.chinshape').val(),
            neckwidth: $('.neckwidth').val(),
            hairmodel: $('.hairmodel').val(),
            hairfirstcolor: $('.hairfirstcolor').val(),
            hairsecondarycolor: $('.hairsecondarycolor').val(),
            eyebrows: $('.eyebrows').val(),
            eyebrowscolor: $('.eyebrowscolor').val(),
            beard: $('.beard').val(),
            beardcolor: $('.beardcolor').val(),
            chest: $('.chest').val(),
            chestcolor: $('.chestcolor').val(),
            blush: $('.blush').val(),
            blushcolor: $('.blushcolor').val(),
            lipstick: $('.lipstick').val(),
            lipstickcolor: $('.lipstickcolor').val(),
            blemishes: $('.blemishes').val(),
            ageing: $('.ageing').val(),
            complexion: $('.complexion').val(),
            sundamage: $('.sundamage').val(),
            freckles: $('.freckles').val(),
            makeup: $('.makeup').val(),
            shapemix: $('.shapemix').val(),
            skincolor: $('.skincolor').val(),
            makeupintensity: $('.makeupintensity').val(),
            makeupcolor: $('.makeupcolor').val(),
            lipstickintensity: $('.lipstickintensity').val(),
            eyebrowintensity: $('.eyebrowintensity').val(),
            beardintentisy: $('.beardintentisy').val(),
            blushintentisy: $('.blushintentisy').val(),
        }));
    });

    $('.submit').on('click', function (e) {
        e.preventDefault();

        $.post('http://barbershop/updateSkin', JSON.stringify({
            value: true,
            father: $('.father').val(),
            mother: $('.mother').val(),
            eyescolor: $('.eyescolor').val(),
            eyebrowsheight: $('.eyebrowsheight').val(),
            eyebrowsmargin: $('.eyebrowsmargin').val(),
            nose: $('.nose').val(),
            noseheight: $('.noseheight').val(),
            nosemargin: $('.nosemargin').val(),
            nosebridge: $('.nosebridge').val(),
            nosetip: $('.nosetip').val(),
            noseshift: $('.noseshift').val(),
            cheekboneheight: $('.cheekboneheight').val(),
            cheekbonemargin: $('.cheekbonemargin').val(),
            cheekbone: $('.cheekbone').val(),
            lips: $('.lips').val(),
            lipsmargin: $('.lipsmargin').val(),
            lipsheight: $('.lipsheight').val(),
            chinlength: $('.chinlength').val(),
            chinposition: $('.chinposition').val(),
            chinwidth: $('.chinwidth').val(),
            chinshape: $('.chinshape').val(),
            neckwidth: $('.neckwidth').val(),
            hairmodel: $('.hairmodel').val(),
            hairfirstcolor: $('.hairfirstcolor').val(),
            hairsecondarycolor: $('.hairsecondarycolor').val(),
            eyebrows: $('.eyebrows').val(),
            eyebrowscolor: $('.eyebrowscolor').val(),
            beard: $('.beard').val(),
            beardcolor: $('.beardcolor').val(),
            chest: $('.chest').val(),
            chestcolor: $('.chestcolor').val(),
            blush: $('.blush').val(),
            blushcolor: $('.blushcolor').val(),
            lipstick: $('.lipstick').val(),
            lipstickcolor: $('.lipstickcolor').val(),
            blemishes: $('.blemishes').val(),
            ageing: $('.ageing').val(),
            complexion: $('.complexion').val(),
            sundamage: $('.sundamage').val(),
            freckles: $('.freckles').val(),
            makeup: $('.makeup').val(),
            shapemix: $('.shapemix').val(),
            skincolor: $('.skincolor').val(),
            makeupintensity: $('.makeupintensity').val(),
            makeupcolor: $('.makeupcolor').val(),
            lipstickintensity: $('.lipstickintensity').val(),
            eyebrowintensity: $('.eyebrowintensity').val(),
            beardintentisy: $('.beardintentisy').val(),
            blushintentisy: $('.blushintentisy').val(),
        }));
    });

    document.onkeydown = function (data) {
        if (data.which == 65) {
            $.post('http://barbershop/rotate', JSON.stringify("right"));
        }
        if (data.which == 68) {
            $.post('http://barbershop/rotate', JSON.stringify("left"));
        }
    }
});