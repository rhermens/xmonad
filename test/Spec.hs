import Test.Hspec
import Lib

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
    describe "XResources" $ do
        it "parses colors" $ do
            resources <- getXResources
            background resources `shouldBe` "#24283b"
