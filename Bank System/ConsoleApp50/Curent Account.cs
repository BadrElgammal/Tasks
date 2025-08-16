using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;
using System.Xml.Linq;

namespace ConsoleApp50
{
    internal class Current_Account:Bank_Account
    {
        public decimal Overdraft_Limit { get; set; }
        public Current_Account(decimal Overdraft_Limit,string name, string national_ID, DateTime date_of_birth) : base(name, national_ID, date_of_birth)
        {
            this.Overdraft_Limit = Overdraft_Limit;
        }
        public override void Withdraw(decimal amount)
        {
            if (Current_Balance + Overdraft_Limit >= amount)
            {
                Current_Balance -= amount;
                bank.AddToTransaction("Withdraw", amount, "Money withdrawn with overdraft");
            }
        }
        public override void Transfer(Bank_Account toAccount, decimal amount)
        {
            if (Current_Balance + Overdraft_Limit >= amount)
            {
                Withdraw(amount);
                toAccount.Deposit(amount);
                bank.AddToTransaction("Transfer", amount, $"Transferred to {toAccount.Account_Number}");
            }
        }
    }
}
