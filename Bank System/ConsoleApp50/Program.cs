namespace ConsoleApp50
{
    internal class Program
    {
        
        
        static void Main(string[] args)
        {
            Bank bank = new Bank();
            while (true)
            {
                Console.WriteLine("*****************************************");
                Console.WriteLine("Create Account write : 1" +
                    "\nYou Have Account Write : 2");
                string startChoose=Console.ReadLine();
                string choose = "";
                if (startChoose=="1")
                {
                    bank.Create_Account();
                    continue;
                }
                else if(startChoose=="2")
                {
                    Console.WriteLine("*****************************************");
                    Console.WriteLine("deposit or withdraw or transfer : 1" +
                       "\nUpdate Account write : 2 " +
                    "\nDelete Account Write : 3" +
                    "\nSearch for customers Write : 4" +
                    "\nBank Report write : 5" +
                    "\nShow All Transaction Write : 6" +
                    "\nif you want to clouse write : 7" );
                    choose = Console.ReadLine();
                }
                else
                {
                    Console.WriteLine("Error Try again");
                    continue;
                }
                switch (choose.ToLower())
                {
                    case "1":
                        {
                            bank.Do_Transaction();
                            break;
                        }
                    case "2":
                        {
                            bank.Update_Account();
                            break;
                        }
                    case "3":
                        {
                            bank.Delete_Account();
                            break;
                        }
                    case "4":
                        {
                            bank.Search_Account();
                            break;
                        }
                    case "5":
                        {
                            bank.BankReport();
                            break;
                        }
                    case "6":
                        {
                            bank.ShowTransactions();
                            break;
                        }
                    case "7":
                        {
                            return;
                            break;
                        }
                    default:
                        {
                            Console.WriteLine("Error try again");
                            break;
                        }
                }
            }
        }
    }
}
