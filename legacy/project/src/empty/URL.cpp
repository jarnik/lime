#include <URL.h>

namespace nme
{


class EmptyURLLoader : public URLLoader
{
public:
   EmptyURLLoader(URLRequest &inRequest)
   {
   }

   ~EmptyURLLoader()
   {
   }

   URLState getState()
   {
      return urlError;
   }

   int bytesLoaded()
   {
      return 0;
   }

   int bytesTotal()
   {
      return 0;
   }

   int  getHttpCode()
   {
      return 404;
   }

   const char *getErrorMessage()
   {
      return "";
   }

   ByteArray releaseData()
   {
      return ByteArray();
   }

   void  getCookies( std::vector<std::string> &outCookies )
   {
   }
};


URLLoader *URLLoader::create(URLRequest &inRequest)
{
   return new EmptyURLLoader(inRequest);
}

bool URLLoader::processAll()
{
   return false;
}

void URLLoader::initialize(const char *inCACertFilePath)
{
}


}
