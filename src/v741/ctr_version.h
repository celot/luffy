#ifndef _CTR_VERSION_H_
#define _CTR_VERSION_H_

/**
\file ctr_version.h
\brief 
\author tyranno
\warning 
\date 2014/11/19
*/

/*Revision history ******************************************
*
*        Author             :
*        Dept            :
*        Revision Date    :
*        Version           :
*
*/

#if defined(CONFIG_CPRN_KLW)
#define CTR_MODEL_NAME "CPRN-KLW"
#elif defined(CONFIG_CPRW_KLW)
#define CTR_MODEL_NAME "CPRW-KLW"
#elif defined(CONFIG_CPRN_NLW)
#define CTR_MODEL_NAME "CPRN-NLW"
#elif defined(CONFIG_CPRW_NLW)
#define CTR_MODEL_NAME "CPRW-NLW"
#else
#define CTR_MODEL_NAME "CPRN-KLW"
#endif

#if defined(CONFIG_CPRN_KLW) || defined(CONFIG_CPRW_KLW)
#define CTR_VERSION_NAME "2.2.38"
#elif defined(CONFIG_CPRN_NLW) || defined(CONFIG_CPRW_NLW) || defined(CONFIG_CPRN_NLW2) || defined(CONFIG_CPRW_NLW2)
#define CTR_VERSION_NAME "2.2.38"
#else
#error "Define Module Type"
#endif

#define CTR_SVN_VERSION "408"

#endif//_CTR_VERSION_H_
