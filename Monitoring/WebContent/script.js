var eles = document.querySelectorAll('.ele');
console.log(eles);
Array.prototype.slice.call(eles).forEach(function (e) {
	alert(eles);
  e.addEventListener('click', toggle);
});
function toggle() {
	  var ls = this.parentNode.getElementsByTagName('ul')[0],
	      styles, display;
      console.log(ls);
      alert(ls);
	  if (ls) {
	    styles = window.getComputedStyle(ls);
	    display = styles.getPropertyValue('display');

	    ls.style.display = (display === 'none' ? 'block' : 'none');
	  }
	}
