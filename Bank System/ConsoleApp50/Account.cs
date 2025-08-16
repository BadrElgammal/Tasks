using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace ConsoleApp50
{
    internal class Bank_Account:Customer
    {
        public int Account_Number;
        public decimal Current_Balance;
        public DateTime Date_Opend;
        public static int Account_Counter = 1000;
        public Bank bank = new Bank();
        public Bank_Account(string name, string national_ID, DateTime date_of_birth):base(name,national_ID,date_of_birth) 
        {
            Account_Number = Account_Counter++;
            Date_Opend = DateTime.Now;
        }
        public virtual void Deposit(decimal amount)
        {
            Current_Balance += amount;
            bank.AddToTransaction("Deposit", amount, "Money deposited");
        }

        public virtual void Withdraw(decimal amount)
        {
            if (Current_Balance >= amount)
            {
                Current_Balance -= amount;
                bank.AddToTransaction("Withdraw", amount, "Money withdrawn");
            }
            else
                Console.WriteLine("you can't withdraw");
        }
        public virtual void Transfer(Bank_Account toAccount, decimal amount)
        {
            if (Current_Balance >= amount)
            {
                Withdraw(amount);
                toAccount.Deposit(amount);
                bank.AddToTransaction("Transfer", amount, $"Transferred to {toAccount.Account_Number}");
            }
        }
        public override string ToString()
        {
            Console.WriteLine("-------------------Account Details------------");
            return $"Account Number : {Account_Number}\t\t Date Open : {Date_Opend} \nName is : {Name} \nNational ID : {National_ID} \nDate_Of_Birth : {Date_Of_Birth} \nCurrent Ballance : {Current_Balance}";
        }
    }
}
