addEventListener('message', function(event){
    var dat = event.data
    if (dat.toggle == 'true') {
        $('.maincon').fadeIn();
    } else if (dat.toggle == 'update') {
        $('.time').html(dat.sure)
        $('.prize').html(dat.para+'$')
    }


});