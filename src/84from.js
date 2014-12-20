/*
//
// FROM functions Alasql.js
// Date: 11.12.2014
// (c) 2014, Andrey Gershun
//
*/



// Read JSON file

alasql.from.JSON = function(filename, opts, cb, idx, query) {
	var res;
	//console.log('cb',cb);
	alasql.utils.loadFile(filename,!!cb,function(data){
		res = JSON.parse(data);	
		if(cb) res = cb(res, idx, query);
	});
	return res;
};

alasql.from.TXT = function(filename, opts, cb, idx, query) {
	var res;
	alasql.utils.loadFile(filename,!!cb,function(data){
		res = data.split(/\r?\n/);
		for(var i=0, ilen=res.length; i<ilen;i++) {
			res[i] = [res[i]];
		}
		if(cb) res = cb(res, idx, query);
	});
	return res;
};

alasql.from.TAB = alasql.from.TSV = function(filename, opts, cb, idx, query) {
	if(!opts) opts = {};
	opts.separator = '\t';
	return alasql.from.CSV(filename, opts, cb, idx, query);
};

alasql.from.CSV = function(filename, opts, cb, idx, query) {
	var opt = {
		separator: ',',
		quote: '"'
	};
	alasql.utils.extend(opt, opts);
	var res;
	alasql.utils.loadFile(filename,!!cb,function(text){

		var delimiterCode = opt.separator.charCodeAt(0);
		var quoteCode = opt.quote.charCodeAt(0);

      	var EOL = {}, EOF = {}, rows = [], N = text.length, I = 0, n = 0, t, eol;
	      function token() {
	        if (I >= N) return EOF;
	        if (eol) return eol = false, EOL;
	        var j = I;
	        if (text.charCodeAt(j) === quoteCode) {
	          var i = j;
	          while (i++ < N) {
	            if (text.charCodeAt(i) === quoteCode) {
	              if (text.charCodeAt(i + 1) !== quoteCode) break;
	              ++i;
	            }
	          }
	          I = i + 2;
	          var c = text.charCodeAt(i + 1);
	          if (c === 13) {
	            eol = true;
	            if (text.charCodeAt(i + 2) === 10) ++I;
	          } else if (c === 10) {
	            eol = true;
	          }
	          return text.substring(j + 1, i).replace(/""/g, '"');
	        }
	        while (I < N) {
	          var c = text.charCodeAt(I++), k = 1;
	          if (c === 10) eol = true; else if (c === 13) {
	            eol = true;
	            if (text.charCodeAt(I) === 10) ++I, ++k;
	          } else if (c !== delimiterCode) continue;
	          return text.substring(j, I - k);
	        }
	        return text.substring(j);
	      }

	      while ((t = token()) !== EOF) {
	        var a = [];
	        while (t !== EOL && t !== EOF) {
	          a.push(t);
	          t = token();
	        }

	        if(opt.headers) {
	        	if(n == 0) {
					if(typeof opt.headers == 'boolean') {
		        		hs = a;
					} else if(opt.headers instanceof Array) {
						hs = opt.headers;
		        		var r = {};
		        		hs.forEach(function(h,idx){
		        			r[h] = a[idx];
		        		});
						rows.push(r);
					}

	        	} else {
	        		var r = {};
	        		hs.forEach(function(h,idx){
	        			r[h] = a[idx];
	        		});
	        		rows.push(r);
	        	}
	        	n++;
	        } else {
	    	    rows.push(a);
	    	}
	      }

	      res = rows;

		if(opt.headers) {
			if(query && query.sources && query.sources[idx]) {
				var columns = query.sources[idx].columns = [];
				hs.forEach(function(h){
					columns.push({columnid:h});
				});
			};
		};

if(false) {
		res = data.split(/\r?\n/);
		if(opt.headers) {
			if(query && query.sources && query.sources[idx]) {
				var hh = [];
				if(typeof opt.headers == 'boolean') {
					hh = res.shift().split(opt.separator);
				} else if(opt.headers instanceof Array) {
					hh = opt.headers;
				}
				var columns = query.sources[idx].columns = [];
				hh.forEach(function(h){
					columns.push({columnid:h});
				});
				for(var i=0, ilen=res.length; i<ilen;i++) {
					var a = res[i].split(opt.separator);
					var b = {};
					hh.forEach(function(h,j){
						b[h] = a[j];
					});
					res[i] = b;
				}
//				console.log(res[0]);
			}	
		} else {
			for(var i=0, ilen=res.length; i<ilen;i++) {
				res[i] = res[i].split(opt.separator);
			}
		}

};

		if(cb) res = cb(res, idx, query);
	});
	return res;
};


alasql.from.XLS = function(filename, opts, cb, idx, query) {
	if(typeof exports === 'object') {
		var X = require('xlsjs');
	} else {
		var X = window.XLS;
		if(!X) {
			throw new Error('XLS library is not attached');
		}
	}
	return XLSXLSX(X,filename, opts, cb, idx, query);
};

alasql.from.XLSX = function(filename, opts, cb, idx, query) {
	if(typeof exports === 'object') {
		var X = require('xlsx');
	} else {
		var X = window.XLSX;
		if(!X) {
			throw new Error('XLSX library is not attached');
		}
	}
	return XLSXLSX(X,filename, opts, cb, idx, query);
};

function XLSXLSX(X,filename, opts, cb, idx, query) {
	var opt = {};
	if(!opts) opts = {};
	alasql.utils.extend(opt, opts);
	var res;

	alasql.utils.loadBinaryFile(filename,!!cb,function(data){
		var workbook = X.read(data,{type:'binary'});
//		console.log(workbook);
		var sheetid;
		if(typeof opt.sheetid == 'undefined') {
			sheetid = workbook.SheetNames[0];
		} else {
			sheetid = opt.sheetid;
		};
		var range;
		if(typeof opt.range == 'undefined') {
			range = workbook.Sheets[sheetid]['!ref'];
		} else {
			range = opt.range;
			if(workbook.Sheets[sheetid][range]) range = workbook.Sheets[sheetid][range];
		};
		var rg = range.split(':');
		var col0 = rg[0].match(/[A-Z]+/)[0];
		var row0 = rg[0].match(/[0-9]+/)[0];
		var col1 = rg[1].match(/[A-Z]+/)[0];
		var row1 = rg[1].match(/[0-9]+/)[0];
//		console.log(114,rg,col0,col1,row0,row1);

		var hh = {};
		for(var j=alasql.utils.xlscn(col0);j<=alasql.utils.xlscn(col1);j++){
			var col = alasql.utils.xlsnc(j);
			if(opt.headers) {
				hh[col] = workbook.Sheets[sheetid][col+""+row0].v;
			} else {
				hh[col] = col;
			}
		}
		var res = [];
		if(opt.headers) row0++;
		for(var i=row0;i<=row1;i++) {
			var row = {};
			for(var j=alasql.utils.xlscn(col0);j<=alasql.utils.xlscn(col1);j++){
				var col = alasql.utils.xlsnc(j);
				if(workbook.Sheets[sheetid][col+""+i]) {
					row[hh[col]] = workbook.Sheets[sheetid][col+""+i].v;
				}
			}
			res.push(row);
		}

		if(cb) res = cb(res, idx, query);
	}, function(err){
		throw err;
	});

	return res;
};
