using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace GracjanFilipekEFLab
{
    //[Table("Customers")]
    public class Customer : Company
    {
        public float Discount { get; set; } = 0;
    }
}
