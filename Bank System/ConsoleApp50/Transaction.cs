using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace ConsoleApp50
{
    internal class Transaction
    {
        public DateTime Date {  get; set; }
        public string Type { get; private set; }
        public decimal Amount { get; private set; }
        public string Description { get; private set; }

        public Transaction(string type, decimal amount, string description)
        {
            Date=DateTime.Now;
            Type = type;
            Amount = amount;
            Description = description;
        }

        public override string ToString()
        {
            return $"{Date} | {Type} | {Amount:C} | {Description}";
        }
    }
}

