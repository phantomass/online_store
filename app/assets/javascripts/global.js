!function ($) {
    $(function() {
        $('.carousel').carousel({
            interval: 4000
        });
    });
}(window.jQuery);

$(function() {
    $('.caption').dotdotdot({
        after: 'a.readmore'
    });
});