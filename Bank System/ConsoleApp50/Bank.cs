using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;
using System.Xml.Linq;

namespace ConsoleApp50
{
    internal class Bank
    {
        public string Branch { get; private set; } = "0101";
        public string BName { get; private set; } = "Bank01";
        public static List<Bank_Account> accounts = new List<Bank_Account>();
        public static List<Transaction> transactions = new List<Transaction>();
        public int index_of_Account(string National_ID)
        {
            int index = 0;
            for (int i = 0; i < accounts.Count; i++)
            {
                if (accounts[i].National_ID == National_ID)
                    index = i;
            }
            return index;
        }

        public void Create_Account()
        {
            Console.WriteLine("Create Saving Account Write : 1\nCreate Current Account Write : 2");
            string Choose=Console.ReadLine();
            Console.Write("write Your Name : ");
            string Name = Console.ReadLine();
            Console.Write("Write Your National ID : ");
            string National_ID = Console.ReadLine();
            Console.Write("Write Date Of Birth : ");
            DateTime Date_Of_Birth = DateTime.Parse(Console.ReadLine());
            if(Choose=="1")
            {
                Console.Write("Write interest Rate : ");
                decimal interest_Rate=decimal.Parse(Console.ReadLine());
                Saving_Account SA = new Saving_Account(interest_Rate, Name, National_ID, Date_Of_Birth);
                accounts.Add(SA);
                Console.WriteLine("Account is created");
                Console.WriteLine("********************************************");
            }
            else if(Choose=="2")
            {
                Console.Write("Write Overdraft Limit : ");
                decimal Overdraft_Limit = decimal.Parse(Console.ReadLine());
                Saving_Account CA = new Saving_Account(Overdraft_Limit, Name, National_ID, Date_Of_Birth);
                accounts.Add(CA);
                Console.WriteLine("Account is created");
                Console.WriteLine("********************************************");
            }
            else
                Console.WriteLine("Error try agin");
            
        }
        public void Update_Account()
        {
            Console.Write("Write Your National ID :");
            string ID = Console.ReadLine();
            foreach (Bank_Account item in accounts)
            {
                if (item.National_ID == ID)
                    item.Ubdate_Customer_Details();
            }
            Console.WriteLine("********************************************");

        }
        public void Delete_Account()
        {
            Console.Write("Write Your National ID : ");
            string Account_ID = Console.ReadLine();
            for (int i = 0; i < accounts.Count; i++)
            {
                if (accounts[i].National_ID == Account_ID)
                {
                    if (accounts[i].Current_Balance == 0)
                    {
                        accounts.Remove(accounts[i]);
                        Console.WriteLine("Done Remove Account");
                    }
                    else
                        Console.WriteLine($"The account have Balance : {accounts[i].Current_Balance}");
                }

            }
            Console.WriteLine("********************************************");

        }
        public void Search_Account()
        {
            Console.Write("Write your name or National ID : ");
            string choose = Console.ReadLine();
            foreach (Bank_Account item in accounts)
            {
                if (item.Name == choose || item.National_ID == choose)
                    Console.WriteLine($"Bank Name : {BName} \t\tBank Branch : {Branch} \n{item}");
            }
        }

        public void AddToTransaction(string type,decimal amount,string description)
        {
            Transaction T=new Transaction(type,amount,description);
            transactions.Add(T);
        }
        public void ShowTransactions()
        {
            foreach (Transaction item in transactions)
                Console.WriteLine(item);
        }
        public decimal GetTotalBalance()
        {
            decimal totalBalance = 0;
            foreach(Bank_Account item in  accounts)
            {
                 totalBalance += item.Current_Balance;
            }
            return totalBalance;
        }
        public void BankReport()
        {
            Console.WriteLine($"Bank: {BName} - Branch: {Branch}");
            foreach (Bank_Account item in accounts)
            {
                Console.WriteLine(item);
            }
        }
        public void Do_Transaction()
        {
            string National_ID;
            decimal amount;
            string to_Account;
            Console.WriteLine("deposit write : 1" +
                        "\nwithdraw write : 2" +
                        "\nTransfer mony to another account write : 3");
            string choose=Console.ReadLine();
            Console.Write("Write Your National ID : ");
            National_ID = Console.ReadLine();
            switch (choose)
            {
                case "1":
                    {
                        Console.Write("Write amount : ");
                        amount = decimal.Parse(Console.ReadLine());
                        accounts[index_of_Account(National_ID)].Deposit(amount);
                        break;
                    }
                case "2":
                    {
                        Console.Write("Write amount : ");
                        amount = decimal.Parse(Console.ReadLine());
                        accounts[index_of_Account(National_ID)].Withdraw(amount);
                        break;
                    }
                case "3":
                    {
                        Console.Write("write National id of another account : ");
                        to_Account=Console.ReadLine();
                        Console.Write("Write amount : ");
                        amount = decimal.Parse(Console.ReadLine());
                        accounts[index_of_Account(National_ID)].Transfer(accounts[index_of_Account(to_Account)], amount);
                        break;
                    }
                default:
                    {
                        Console.WriteLine("Error try agin");
                        break;
                    }
            }
        }
    }
}
