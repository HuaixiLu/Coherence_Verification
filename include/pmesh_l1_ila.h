/// \file the cache ila example of OpenPiton L1 ILA (in aim of verifying the cache coherence protocol)
///  Huaixi Lu (huaixil@princeton.edu)
///


#ifndef PMESH_L1_ILA_H__
#define PMESH_L1_ILA_H__

#include <ilang/ilang++.h>
#include <vector>

using namespace ilang;

#define NOC_MSG_WIDTH  8
#define CORE_MSG_WIDTH 2
#define MESI_WIDTH     2
#define DATA_WIDTH     16
#define TAG_WIDTH      3
#define DIR_WIDTH    4

#define b0 BoolConst(false)
#define b1 BoolConst(true)
#define zero_data BvConst(0,DATA_WIDTH)

/// \brief the class of PMESH L2 ila
class PMESH_L1_ILA {

public:
  // --------------- MEMBERS ----------- //
  /// the ila model
  Ila model;
  
  // --------------- CONSTRUCTOR ----------- //
  PMESH_L1_ILA();
  
protected:

  // -------- Output -------- //

  ExprRef msg1_type      ;
  ExprRef msg1_data      ;
  ExprRef msg1_tag       ;

  ExprRef msg3_type      ;
  ExprRef msg3_data      ;
  ExprRef msg3_tag       ;

  // -------- Input ------- //
  ExprRef msg2_type;
  ExprRef msg2_data;
  ExprRef msg2_tag;
  ExprRef mesi_send;

  ExprRef core_req;
  ExprRef core_tag;
  ExprRef core_data;

  // ------- Cache AS ------- //
  ExprRef cache_tag;
  ExprRef cache_state;
  ExprRef cache_data;

  // --------------- HELPERS -------- //
  /// specify a nondeterministic value within range [low,high]
  ExprRef unknown_range(unsigned low, unsigned high);
  /// a nondeterministic choice of a or b
  static ExprRef unknown_choice(const ExprRef& a, const ExprRef& b);
  /// a nondeterminstic bitvector const of width
  static FuncRef unknown(unsigned width);
  /// a helper function to concat a vector of express
  static ExprRef lConcat(const std::vector<ExprRef> & l);
  /// use a relation
  ExprRef Map(const std::string & name, unsigned retLen, const ExprRef & val);
  /// build a map relation
  ExprRef NewMap(const std::string & name, unsigned inLen, unsigned outLen);
  /// Set update function to a map  
  void MapUpdate(InstrRef & instr, const std::string & name, const ExprRef & idx, const ExprRef & val) ;
  /// Set update function to a map
  void MapUpdate(InstrRef & instr, const std::string & name, const ExprRef & idx, 
    const ExprRef & cond, const ExprRef & val);
}; // class PMESH_L2_ILA

#endif // PMESH_L2_ILA_H__

