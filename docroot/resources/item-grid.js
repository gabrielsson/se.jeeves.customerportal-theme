    
    
     
    
    

println('<div class="span3" style="overflow: hidden">');
println('<div class="thumbnail" style="height: 600px;" >');

var pathList = itemDocumentUrlsMap.get(item.getItemNumber().toLowerCase());
resourceUrl.setResourceID('itemDetails');
resourceUrl.setParameter('itemNumber', item.getItemNumber());
println('<div class="image-wrapper">');
if (pathList != null && !pathList.isEmpty()) {
 var imageId = renderResponse.getNamespace() + '_img';
 println('<img style=""  type="image/jpeg" src="' + pathList.get(0)
   + '?imageThumbnail=1" alt="' + item.getDescription() + '" />');
}
println('</div>');// image-wrapper

slist = item.getPackageItems();
println('<div class="caption" style="overflow: hidden;">');

println('<h3 class="product-title" style="overflow: hidden"><a href="javascript:void(0)" onClick="getItemDetails(\''
  + item.getItemNumber() + '\',\'' + resourceUrl.toString() + '\')">');
println(item.getDescription());
println('</a></h3>');
println('<h3 class="product-price" style="overflow: hidden">');

if (1 <= item.getWebpublish().intValue() && item.getWebpublish().intValue() < 3) {
 println('<span>'
   + JeevesUserUtil.getCurrencyCode(themeDisplay.getUser(),
     portletSession) + '</span>&nbsp');
 var packageSize = item.getPackageSizeSales();
 if (!packageSize) {
  packageSize = 0;
 }
 println('<span id="' + renderResponse.getNamespace()
   + 'price" data-itemNumber="' + item.getItemNumber()
   + '" data-packageSize="' + packageSize + '"></span>&nbsp');
 println("<span id='" + renderResponse.getNamespace()
   + "priceBracket' data-itemNumber='" + item.getItemNumber()
   + "'></span>");
}
println('</h3>');
println('<p class="product-stock">');

if (item.getWebpublish().intValue() == 1) {
 var size = item.getPackageSizeSales();
 var qty = 1;
 if (size != null && size.compareTo(java.math.BigDecimal.ZERO) != 0) {
  qty = size.doubleValue();
 }
 resourceUrl.setPortletMode('view');
 if (item.getWebpublish().intValue() < 3) {
  println(messageSource.getMessage("itemlist-VIEW-in-stock-STRING", null,
    renderRequest.getLocale())
    + ': ');

  var packageSize = item.getPackageSizeSales();
  if (!packageSize) {
   packageSize = 0;
  }
  print("<span id='" + renderResponse.getNamespace()
    + "stock' data-itemNumber='" + item.getItemNumber()
    + "' data-packageSize='" + packageSize + "'></span>");
  println("<span> " + item.getUnit() + "</span>");
 }
 println('</p>');
 
 println('<p class="product-sku">');
 println('SKU: ' + item.getItemNumber());
 println('</p>');
 
 println('<p class="product-description" style="overflow: hidden">');
 println(item.getDescription2() != null ? item.getDescription2() : "");
 println('</p>');
 sBuyDisabled = "";
 if (false) {// JeevesSessionUtil.getAllowed2Buy(portletSession) == false)
  sBuyDisabled = "disabled='disabled' style='color:grey;'";
 }
 println('<div class="product-add-to-cart input-append">');
 println('<input type="text" ' + sBuyDisabled
   + ' size="4" class="input-mini" id="'
   + renderResponse.getNamespace() + 'quantity" value="' + qty + '"/>');
 println('<button id="'
   + renderResponse.getNamespace()
   + 'buy" data-item-number="'
   + item.getItemNumber()
   + '" class="btn btn-primary" '
   + sBuyDisabled
   + '">'
   + messageSource.getMessage("itemlist-VIEW-article-buy-BUTTON",
     null, renderRequest.getLocale()) + '</button>');
 println('</div>');// input-append
 renderUrl.setParameter("oldWindowState", "normal");
}
println('</div>'); // caption

println('</div>'); // thumbnail

println('</div>'); // span