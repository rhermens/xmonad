import Test.Hspec
import Lib

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "parseLine" $ do
    it "parses a single line" $ do
      let line = "*background: #24283b"
      parseLine line `shouldBe` ("*background", "#24283b")

    it "parses a single line with spaces" $ do
      let line = "*.background:   #232a2e"
      parseLine line `shouldBe` ("*.background", "#232a2e")

  describe "getKey" $ do
    it "parses a single line" $ do
      let db = [("*background", "#24283b"), ("*foreground", "#c0caf5")]
      getKey db "*background" `shouldBe` "#24283b"

  describe "resources" $ do
    it "parses full xresources" $ do
      db <- getXResources
      print db
