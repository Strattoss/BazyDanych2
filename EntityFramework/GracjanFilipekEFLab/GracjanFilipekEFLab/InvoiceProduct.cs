using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GracjanFilipekEFLab
{
    public class InvoiceProduct
    {
        public int InvoiceId { get; set; }
        public Invoice Invoice { get; set; }

        public int ProductId { get; set; }
        public Product Product { get; set; }

        [Required]
        public int Quantity { get; set; }

        public void Sell()
        {
            if (Product.UnitsOnStock - Quantity < 0)
            {
                throw new ArgumentOutOfRangeException("Cannot sell " + Quantity + " units, product has only " + Product.UnitsOnStock + " units available");
            }

            Product.UnitsOnStock -= Quantity;
            Product.InvoiceProducts.Add(this);
            Invoice.InvoiceProducts.Add(this);
        }
    }
}
