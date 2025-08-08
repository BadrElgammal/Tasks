using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace Task_2_
{
    internal class BankAccount
    {
        const string BankCode = "BNK001";
        readonly DateTime createdDate;
        private string _accountNumber;
        private string _fullName;
        private string _nationalID;
        private string _phoneNumber;
        private string _address;
        private decimal _balance;
        public string FullName
        {
            get { return _fullName; }
            set 
            {
                if(value==null)
                    Console.WriteLine("Invalid name ");
                else
                    _fullName = value; 
            }
        }
        public string  NationalID
        {
            get { return _nationalID; }
            set 
            { 
                if(IsValidNationalID(value))
                     _nationalID = value; 
                else
                    Console.WriteLine("inValid National ID");
            }
        }
        public string PhoneNumber
        {
            get { return _phoneNumber; }
            set 
            { 
                if(IsValidPhoneNumber(value))
                      _phoneNumber = value;
                else
                    Console.WriteLine("Must start with \"01\" and be 11 digits long");
            }
        }
        public decimal Ballance
        {
            get { return _balance; }
            set 
            { 
                if(value>=0)
                   _balance = value;
                else
                    Console.WriteLine("Ballance Must be greater than or equal to 0");
            }
        }
        public string Address
        {
            get { return _address; }
            set { _address = value; }
        }
        public BankAccount()
        {
            this.createdDate = DateTime.Now;
            this._accountNumber = "94539034906";
            FullName = "Badr Elgammal";
            NationalID = "39573628495748";
            PhoneNumber = "01287486739";
            Address = "cairo";
            Ballance = 100;
        }
        public BankAccount(string fullName, string nationalID, string phoneNumber, string address, decimal balance )
        {
            FullName = fullName;
            NationalID = nationalID;
            PhoneNumber = phoneNumber;
            Address = address;
            Ballance = balance;
        }
        public BankAccount( string accountNumber, string fullName, string nationalID, string phoneNumber, string address, decimal balance=0)
        {
            createdDate = DateTime.Now;
            _accountNumber = accountNumber;
            FullName = fullName;
            NationalID = nationalID;
            PhoneNumber = phoneNumber;
            Address = address;
            Ballance = balance;
        }

        public bool IsValidNationalID(string nationalID)
        {
            if (nationalID.Length == 14)
                return true;
            else
                return false;
        }
        public bool IsValidPhoneNumber(string PhoneNumber)
        {
            if(PhoneNumber.Substring(0,2)=="01"&& PhoneNumber.Length==11)
                return true;
            else
                return false;
        }

        public void ShowAccountDetails()
        {
            Console.WriteLine($"the Bank Code is : {BankCode} \n " +
                $"Account Number : {_accountNumber} \t\t created in : {createdDate}\n" +
                $"Name : {_fullName} \t\t National ID : {_nationalID} \t\t phone Number :{_phoneNumber}\n" +
                $"Address : {_address}\n" +
                $"Ballance : {_balance}");
        }

    }
}
