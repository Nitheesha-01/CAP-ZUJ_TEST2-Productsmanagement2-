sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"com/test/productsmgmt/test/integration/pages/ProductsList",
	"com/test/productsmgmt/test/integration/pages/ProductsObjectPage"
], function (JourneyRunner, ProductsList, ProductsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('com/test/productsmgmt') + '/test/flp.html#app-preview',
        pages: {
			onTheProductsList: ProductsList,
			onTheProductsObjectPage: ProductsObjectPage
        },
        async: true
    });

    return runner;
});

