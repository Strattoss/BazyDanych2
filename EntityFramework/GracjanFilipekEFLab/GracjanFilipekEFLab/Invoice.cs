using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GracjanFilipekEFLab
{
    public class Invoice
    {
        [Key]
        public int InvoiceNumber { get; set; }
        public ICollection<InvoiceProduct> InvoiceProducts { get; } = new HashSet<InvoiceProduct>();
    }
}
