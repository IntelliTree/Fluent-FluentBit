#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "PerlFluentBit.h"

#ifndef newSVivpv
static SV *newSVivpv(IV ival, const char *pval) {
   SV *s= newSVpv(pval, 0);
   SvIOK_on(s);
   SvIV_set(s, ival);
   return s;
}
#endif

MODULE = Fluent::LibFluentBit              PACKAGE = Fluent::LibFluentBit

flb_ctx_t*
flb_create()

int
flb_service_set(ctx, ...)
   flb_ctx_t *ctx
   INIT:
      int i= 1;
      const char *k_str, *v_str;
      int success= 1;
	CODE:
      // final argmuent either must not exist or be undef
      if ((items-1) & 1) {
         if (SvOK(ST(items-1)))
            croak("Arguments must be even-length (key,value) list optionally followed by undef");
      }
		while (i+1 < items) {
         k_str= SvPV_nolen(ST(i));
         v_str= SvPV_nolen(ST(i+1));
         success= flb_service_set(ctx, k_str, v_str, NULL) >= 0 && success;
         i+= 2;
      }
      RETVAL= success;
	OUTPUT:
		RETVAL

int
flb_input(ctx, name, data=NULL)
   flb_ctx_t *ctx
   const char *name
   void *data

int
flb_input_set(ctx, in_ffd, ...)
   flb_ctx_t *ctx
   int in_ffd
   INIT:
      int i= 2;
      const char *k_str, *v_str;
      int success= 1;
   CODE:
      // final argmuent either must not exist or be undef
      if ((items-2) & 1) {
         if (SvOK(ST(items-1)))
            croak("Arguments must be even-length (key,value) list optionally followed by undef");
      }
		while (i+1 < items) {
         k_str= SvPV_nolen(ST(i));
         v_str= SvPV_nolen(ST(i+1));
         success= flb_input_set(ctx, in_ffd, k_str, v_str, NULL) >= 0 && success;
         i+= 2;
      }
      RETVAL= success;
	OUTPUT:
		RETVAL

int
flb_filter(ctx, name, data=NULL)
   flb_ctx_t *ctx
   const char *name
   void *data

int
flb_filter_set(ctx, flt_ffd, ...)
   flb_ctx_t *ctx
   int flt_ffd
   INIT:
      int i= 2;
      const char *k_str, *v_str;
      int success= 1;
   CODE:
      // final argmuent either must not exist or be undef
      if ((items-2) & 1) {
         if (SvOK(ST(items-1)))
            croak("Arguments must be even-length (key,value) list optionally followed by undef");
      }
		while (i+1 < items) {
         k_str= SvPV_nolen(ST(i));
         v_str= SvPV_nolen(ST(i+1));
         success= flb_filter_set(ctx, flt_ffd, k_str, v_str, NULL) >= 0 && success;
         i+= 2;
      }
      RETVAL= success;
	OUTPUT:
		RETVAL

int
flb_output(ctx, name, data=NULL)
   flb_ctx_t *ctx
   const char *name
   void *data

int
flb_output_set(ctx, out_ffd, ...)
   flb_ctx_t *ctx
   int out_ffd
   INIT:
      int i= 2;
      const char *k_str, *v_str;
      int success= 1;
   CODE:
      // final argmuent either must not exist or be undef
      if ((items-2) & 1) {
         if (SvOK(ST(items-1)))
            croak("Arguments must be even-length (key,value) list optionally followed by undef");
      }
		while (i+1 < items) {
         k_str= SvPV_nolen(ST(i));
         v_str= SvPV_nolen(ST(i+1));
         success= flb_output_set(ctx, out_ffd, k_str, v_str, NULL) >= 0 && success;
         i+= 2;
      }
      RETVAL= success;
	OUTPUT:
		RETVAL

int
flb_start(ctx)
   flb_ctx_t *ctx

int
flb_stop(ctx)
   flb_ctx_t *ctx

void
flb_destroy(obj)
   SV *obj
   INIT:
      flb_ctx_t *ctx= PerlFluentBit_get_ctx_mg(obj);
   CODE:
      if (ctx) {
         flb_destroy(ctx);
         PerlFluentBit_set_ctx_mg(obj, NULL); // unset magic so that can't be called twice
      }

int
flb_lib_push(ctx, in_ffd, data_sv, len_sv=NULL)
   flb_ctx_t *ctx
   int in_ffd
   SV *data_sv
   SV *len_sv
   INIT:
      size_t len;
      const char *data= SvPV(data_sv, len);
   CODE:
      // Use the shorter of the user-supplied length or the actual string length
      if (len_sv && SvIV(len_sv) < len)
         len= SvIV(len_sv);
      RETVAL= flb_lib_push(ctx, in_ffd, data, len);
   OUTPUT:
      RETVAL

int
flb_lib_config_file(ctx, path)
   flb_ctx_t *ctx
   const char *path

BOOT:
  HV* stash= gv_stashpv("Fluent::LibFluentBit", GV_ADD);
  newCONSTSUB(stash, "FLB_LIB_ERROR", newSVivpv(FLB_LIB_ERROR, "FLB_LIB_ERROR"));
  newCONSTSUB(stash, "FLB_LIB_NONE", newSVivpv(FLB_LIB_NONE, "FLB_LIB_NONE"));
  newCONSTSUB(stash, "FLB_LIB_OK", newSVivpv(FLB_LIB_OK, "FLB_LIB_OK"));
  newCONSTSUB(stash, "FLB_LIB_NO_CONFIG_MAP", newSVivpv(FLB_LIB_NO_CONFIG_MAP, "FLB_LIB_NO_CONFIG_MAP"));
