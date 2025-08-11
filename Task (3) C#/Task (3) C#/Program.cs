namespace Task__3__C_
{
    public class BankAccount
    {
        public int AccountNumber { get; set; }
        public string AccountName { get; set; }
        public decimal Balance { get; set; }

        public BankAccount(int accountNumber, string accountName, decimal balance)
        {
            AccountNumber = accountNumber;
            AccountName = accountName;
            Balance = balance;
        }
        public virtual decimal CalculateInterest()
        {
            return 0;
        }

        public virtual void ShowAccountDetails()
        {
            Console.WriteLine($"Account Number: {AccountNumber}");
            Console.WriteLine($"Account Name: {AccountName}");
            Console.WriteLine($"Balance: {Balance:C}");
        }
    }

    public class SavingAccount : BankAccount
    {
        public decimal InterestRate { get; set; }

        public SavingAccount(int accountNumber, string accountName, decimal balance, decimal interestRate)
            : base(accountNumber, accountName, balance)
        {
            InterestRate = interestRate;
        }

        public override decimal CalculateInterest()
        {
            return Balance * InterestRate / 100;
        }

        public override void ShowAccountDetails()
        {
            base.ShowAccountDetails();
            Console.WriteLine($"Interest Rate: {InterestRate}%");
            Console.WriteLine($"Calculated Interest: {CalculateInterest():C}");
        }
    }

    public class CurrentAccount : BankAccount
    {
        public decimal OverdraftLimit { get; set; }

        public CurrentAccount(int accountNumber, string accountName, decimal balance, decimal overdraftLimit)
            : base(accountNumber, accountName, balance)
        {
            OverdraftLimit = overdraftLimit;
        }

        public override decimal CalculateInterest()
        {
            return 0; 
        }

        public override void ShowAccountDetails()
        {
            base.ShowAccountDetails();
            Console.WriteLine($"Overdraft Limit: {OverdraftLimit:C}");
        }
    }

    class Program
    {
        static void Main()
        {
            SavingAccount saving = new SavingAccount(101457, "Badr Hassan", 15000, 5);
            CurrentAccount current = new CurrentAccount(102354, "Ali Mohamed", 12000, 2000);

            Console.WriteLine("*************** Saving Account Details ***********");
            saving.ShowAccountDetails();

            Console.WriteLine("\n************* Current Account Details **********");
            current.ShowAccountDetails();
        }
    }
}
