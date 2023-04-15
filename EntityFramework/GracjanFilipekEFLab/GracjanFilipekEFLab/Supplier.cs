using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace GracjanFilipekEFLab
{
    //[Table("Suppliers")]
    public class Supplier: Company
    {
        //public int SupplierID { get; set; }
        [Required]
        [MinLength(8)]
        [MaxLength(20)]
        public string BankAccountNumber { get; set; }
        //public ICollection<Product> suppliedProducts { get; } = new HashSet<Product>();

    }
}
