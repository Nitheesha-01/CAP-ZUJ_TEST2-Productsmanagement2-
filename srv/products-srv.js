const cds = require('@sap/cds');

module.exports = class ProductsMgmtService extends cds.ApplicationService {

    async init() {

        const { Products } = this.entities;

        this.before('CREATE', Products, req => {
            if (req.data.discount == null) {
                req.data.discount = 0;
            }
        });

        this.after('READ', Products, data => {

            const records = Array.isArray(data) ? data : [data];

            records.forEach(item => {
                item.discountedPrice =
                    item.price - (item.price * item.discount) / 100;
            });

        });

        return super.init();
    }
};



// const cds = require('@sap/cds');
// const { data } = require('@sap/cds/lib/dbs/cds-deploy');

// module.exports = class ProductsMgmtService extends cds.ApplicationService {
//     init() {
//         const { Products } = this.entities(ProductsMgmtService);
//         // this.on('CREATE',Products, async req=>{
//         //    await INSERT.into(Products).entries(req.data);
//         //    console.log(result);
//         // });

//         this.before("CREATE", Products, async req => {
//             console.log("Inside before handler on create products");
//             if (req.data.discount === null) {
//                 req.data.discount = 0;
//             }
//         });

//         this.after("READ",Products, async(data,req)=>{
//             console.log("Inside after handler for read on products");
//             for(let i=0;i<data.length;i++){
//                 let PriceAfterDiscount = data[i].price - (data[i].price*data[i].discount)/100;
//                 data[i].discount = data[i].discount + "("+PriceAfterDiscount+")";

//             }
//         })

//         return super.init()
//     }
// }