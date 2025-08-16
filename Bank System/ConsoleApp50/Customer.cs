using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp50
{
    internal class Customer
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string National_ID { get; set; }
        public DateTime Date_Of_Birth { get; set; }


        public Customer( string name, string national_ID, DateTime date_of_birth)
        {
            Name = name;
            National_ID = national_ID;
            Date_Of_Birth = date_of_birth;
        }

        public void Ubdate_Customer_Details()
        {
            Console.Write("Write New Name : ");
            Name = Console.ReadLine();
            Console.Write("Write Date Of Birth : ");
            Date_Of_Birth=DateTime.Parse(Console.ReadLine());
            Console.WriteLine("Done Update Account");
        }
        
    }
}
