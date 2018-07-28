function toggle() {
                    var ls = this.parentNode.getElementsByTagName('ul')[0],
                    styles, display;
                    
                    if (ls) {
                    styles = window.getComputedStyle(ls);
                    display = styles.getPropertyValue('display');
                    
                    ls.style.display = (display === 'none' ? 'block' : 'none');
                    }
                    }
                    
                    
                    var eles = document.querySelectorAll('.ele');
                    
                    Array.prototype.slice.call(eles).forEach(function (e) {
                    e.addEventListener('click', toggle);
                    });