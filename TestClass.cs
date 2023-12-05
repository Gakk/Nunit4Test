using NUnit.Framework;

namespace NUnit4Test
{
    [TestFixture]
    public class TestClass
    {
        [Test]
        public void AssertPass()
        {
            Assert.Pass("Yay, it works!");
        }
    }
}
