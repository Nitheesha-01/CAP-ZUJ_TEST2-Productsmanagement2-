const cds = require('@sap/cds')
const { SELECT } = cds.ql

module.exports = class OrderMgmtService extends cds.ApplicationService {

  async init() {

    const { Orders, OrderItems } = this.entities

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


    return super.init()
  }
}

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