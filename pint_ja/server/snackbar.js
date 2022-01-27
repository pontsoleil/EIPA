/**
 * menu.snackbar.js
 * menu.snackbar module
 *
 * WuWei is a free to use open source knowledge modeling tool.
 * More information on WuWei can be found on WuWei homepage.
 * https://wuwei.space/blog/
 *
 * WuWei is licensed under the MIT License
 * Copyright (c) 2013-2019, Nobuyuki SAMBUICHI
 **/
snackbar = ( function () {
  
  function open(param) { // param: { message, type }
    const snackbarEl = document.getElementById('snackbar');
    const type = param.type;
    const timeout = 3000;
    let message = param.message;
    message = message.trim();
    // message = wuwei.nls.translate(message);
    if (message.length > 128) {
      message = message.substr(0, 128) + '...';
    }
    snackbarEl.innerHTML = message;
    snackbarEl.className = 'show bg-' + type;
    /**
     * Bootstrap 4 Colors
     * bg-success bg-info bg-warning bg-danger bg-secondary bg-dark bg-light
     * text white text-dark
     */
    if (['warning', 'light', 'white', 'transparent'].indexOf(type) >= 0) {
      snackbarEl.style.color = '#303030';
    } else {
      /** primary secondary success info danger dark */
      snackbarEl.style.color = '#efefef';
    }
    setTimeout(() => {
      close();
    }, timeout);
    snackbarEl.classList.remove('hidden');
  }

  function close() {
    const snackbarEl = document.getElementById('snackbar');
    snackbarEl.innerHTML = '';
    snackbarEl.className = '';
  }

  return {
    open: open,
    close: close
  };
})();
