
<script>
$(document).ready(function() {
  // Query String
  var qs = (function(a) {
    if (a == "") return {};
    var b = {};
    for (var i = 0; i < a.length; ++i) {
      var p=a[i].split('=');
      if (p.length != 2) continue;
      b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "));
    }
    return b;
  })(window.location.search.substr(1).split('&'));
  console.log(qs['cat']);

  $.getJSON( "/tahoma/json/categories.json", function( data ) {
    
    // Main Categories
    var items = [];
    $.each( data, function( key, val ) {
      items.push( "<li id='" + key + "'>" + key + "</li>" );
    });

    // Children?
    if (qs['cat'] && data[qs['cat']]['children']) {
      var cat = [];
      $.each( data[qs['cat']]['children'], function( key, val ) {
        cat.push( "<li id='" + key + "'>" + key + "</li>" );
      });

      // Products
      var products = [];
      var product_count = data[qs['cat']]['products'].length;
      var random_product = Math.ceil(Math.random()*product_count);
      var page = 1;
      var max = 100;
      console.log(random_product);
      console.log(product_count);
      console.log(data[qs['cat']]['products'][random_product]);

      var product_count = max - max*page;
      while (product_count < max*page) {
        product_count++;
        console.log(product_count);
        pid = data[qs['cat']]['products'][product_count]
        products.push( "<li id='p_" + pid + "'>" + pid + "</li>" );
      }


      $.each( data[qs['cat']]['products'], function( key, val ) {
        //products.push( "<li id='" + key + "'>" + val + "</li>" );
      });
    }
   
    $( "<ul/>", {
      "class": "cat",
      html: items.join( "" )
    }).appendTo( "body" );


    $( "<ul/>", {
      "class": "cat",
      html: cat.join( "" )
    }).appendTo( "body" );


    $( "<ol/>", {
      "class": "products",
      html: products.join( "" )
    }).appendTo( "body" );
  });

});
</script>