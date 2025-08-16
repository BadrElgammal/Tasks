using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp50
{
    internal class Saving_Account:Bank_Account
    {
        public decimal interest_Rate;
        public Saving_Account(decimal interest_Rate, string name, string national_ID, DateTime date_of_birth) : base(name, national_ID, date_of_birth)
        {
            interest_Rate = interest_Rate;
        }
        public void CalculateMonthlyInterest()
        {
            decimal interest = Current_Balance * (interest_Rate / 100);
            Deposit(interest);
        }
    }
}
