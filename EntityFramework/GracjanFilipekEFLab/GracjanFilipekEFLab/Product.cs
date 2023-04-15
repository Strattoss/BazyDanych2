using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GracjanFilipekEFLab
{
    public class Product
    {
        public int ProductId { get; set; }
        [Required]
        public string ProductName { get; set; }
        [Required]
        public int UnitsOnStock { get; set; }
        public ICollection<InvoiceProduct> InvoiceProducts { get; } = new HashSet<InvoiceProduct>();
    }
}
