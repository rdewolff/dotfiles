function tabNav() {
	const tab = document.getElementById('tabs-container');
	const forward = document.querySelector('.button-toolbar.forward');
	const back = document.querySelector('.button-toolbar.back');
	forward.classList.add('button-tabbar');
	forward.classList.remove('button-toolbar');
	back.classList.add('button-tabbar');
	back.classList.remove('button-toolbar');
	tab.appendChild(back);
	tab.appendChild(forward);
};

let adr = {};
setTimeout(function wait() {
	adr = document.querySelector('.toolbar-addressbar.toolbar');
	if (adr) {
		tabNav();
	}
	else {
		setTimeout(wait, 300);
	}
}, 300);