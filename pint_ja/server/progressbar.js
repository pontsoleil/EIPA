/**
 * menu.progressbar.js
 * menu.progressbar module
 *
 * WuWei is a free to use open source knowledge modeling tool.
 * More information on WuWei can be found on WuWei homepage.
 * https://wuwei.space/blog/
 *
 * WuWei is licensed under the MIT License
 * Copyright (c) 2013-2019, Nobuyuki SAMBUICHI
 **/
progressbar = ( function () {

  function open() {
    const progressbarEl = document.getElementById('progressbar');
    if (progressbarEl){
      progressbarEl.innerHTML = '<div class="bar"></div>';
      const barEl = document.querySelector('#progressbar .bar');
      if (barEl) {
        barEl.style.width = '0%'; 
      }
    }
  }
  
  function move(width) {
    var barEl = document.querySelector('#progressbar .bar');
    if (barEl) {
      barEl.style.width = width + '%'; 
    }
  }

  function close() {
    const progressbarEl = document.getElementById('progressbar');
    if (progressbarEl) {
      progressbarEl.innerHTML = '';
    }
  }

  return {
    open: open,
    move: move,
    close: close
  };
})();
