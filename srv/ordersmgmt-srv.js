const cds = require('@sap/cds')
const { SELECT, UPDATE } = cds.ql

module.exports = class OrderMgmtService extends cds.ApplicationService {

  async init() {

   const { Orders, OrderItems, Products } = this.entities

    this.before(['CREATE', 'PATCH'], OrderItems.drafts, async (req) => {

      const existing =
        await SELECT.one
          .from(OrderItems.drafts)
          .where({ ID: req.data.ID }) || {}

      const quantity =
        Number(req.data.quantity ?? existing.quantity ?? 0)

      const unitPrice =
        Number(req.data.unitPrice ?? existing.unitPrice ?? 0)

      const discount =
        Number(req.data.discount ?? existing.discount ?? 0)

      let totalPrice = quantity * unitPrice

      totalPrice -= totalPrice * discount / 100

      req.data.totalPrice = Number(totalPrice.toFixed(2))
    })

    this.after('READ', Orders, async (orders) => {

      if (!Array.isArray(orders)) {
        orders = [orders]
      }

      for (const order of orders) {

        const items = await SELECT
          .from(OrderItems)
          .where({ order_ID: order.ID })

        const netPrice = items.reduce(
          (sum, item) => sum + Number(item.totalPrice || 0),
          0
        )

        order.netPrice = Number(netPrice.toFixed(2))
      }
    })

    // Delete order Items automatically calculate net price
    let deletedOrderId

this.before('DELETE', OrderItems.drafts, async (req) => {

    const item = await SELECT.one
        .from(OrderItems.drafts)
        .where({ ID: req.data.ID })

    if (item) {
        deletedOrderId = item.order_ID
    }
})

this.after('DELETE', OrderItems.drafts, async () => {

    if (!deletedOrderId) return

    const items = await SELECT
        .from(OrderItems.drafts)
        .where({ order_ID: deletedOrderId })

    const netPrice = items.reduce(
        (sum, item) => sum + Number(item.totalPrice || 0),
        0
    )

    await UPDATE(Orders.drafts)
        .set({
            netPrice: Number(netPrice.toFixed(2))
        })
        .where({
            ID: deletedOrderId
        })

    console.log('Net Price After Delete =', netPrice)
})

/**
* Stock Validation and Stock Reduction
* Executes when draft is activated
*/

this.before('SAVE', Orders, async (req) => {

    console.log("SAVE EVENT TRIGGERED")

    const orderId = req.data.ID

    const items = await SELECT.from(OrderItems.drafts).where({ order_ID: orderId })

    for (const item of items) {

        const product = await SELECT.one.from(Products).where({ ID: item.product_ID })

        if (!product) {
            req.error(`Product not found ${item.product_ID}`)
        }

        if (product.stock < item.quantity) {
            req.error(
                `Insufficient stock for ${product.name}`
            )
        }

        await UPDATE(Products).set({ stock: product.stock - item.quantity}).where({ ID: item.product_ID})

        console.log(
            `Stock Updated => ${product.name} : ${product.stock} -> ${product.stock - item.quantity}`
        )
    }
})

// this.on("Addstock",async)

return super.init()

}
}



// this.before(['CREATE','UPDATE'],Orders,async req=>{
// console.log("Inside before create or update of orders");
// const items = req.data.items || [];
// if(items.length === 0 ){
//   req.error("Order cannot be created without items");
// }else{
//   for(const item of items){
//     console.log(item);
//     const productID = item.product_ID;
//     const product = await SELECT.one.from(Products).where({ID:productID}); 
//     const currentStock = product.stock;
//     const orderQty = item.quantity; 
//     if(currentStock<orderQty){
//       req.error("Insufficient stock for the product"+productID+"-"+product.name);
//     }else{
//       await UPDATE(Products).set({stock:currentStock-orderQty}).where({ID:productID});
//     }
//   }
// }
// }

// )


//     return super.init()
//   }
// }

// const cds = require('@sap/cds');
// const{ SELECT,UPDATE } = require('@sap/cds/lib/ql/cds-ql');


// module.exports = class OrderMgmtService extends cds.ApplicationService {
//     init() {
//         const { Orders, OrderItems } = this.entities;
//         // const { Orders, OrderItems } = this.entities();
//         // const { Orders, OrderItems } = this.entities(OrderMgmtService);

//         this.after("PATCH",OrderItems.drafts,async(data,req)=>{
//             console.log("Inside the patch operation for total order in draftmode");
//             const ID = data.ID;
//             const draftItem = await SELECT.one.from(OrderItems.drafts).where({ID:ID});
//             if(draftItem){
//                 var totalPrice = (draftItem.quantity || 0) * (draftItem.unitprice || 0);
//                 if(draftItem.discount>0){
//                     totalPrice = totalPrice -(totalPrice* draftItem.discount/100);
//                     }
//                     await UPDATE(OrderItems.drafts).set({totalPrice:totalPrice}).where({ID:ID});
//             }

//         }
        
//         )
//     }
// }