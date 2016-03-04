//
// Created by Vadim N. on 04/03/2016.
//

#ifndef MIMIR_ABSTRACT_SELECTION_MODEL_H
#define MIMIR_ABSTRACT_SELECTION_MODEL_H


#include <vector>

#include <Ymir/Graph>


namespace mimir {


    typedef std::string string_t;


    typedef double Qvalue;
    typedef std::vector<Qvalue> QvalueVec;


    class AbstractSelectionModel {
    public:

        virtual Qvalue predict(const Clonotype& clonotype) const = 0;

        virtual QvalueVec predict(const Cloneset &cloneset) const {
            QvalueVec res;
            res.reserve(cloneset.size());
            for (size_t i = 0; i < cloneset.size(); ++i) {
                res.push_back(this->predict(cloneset[i]));
            }
            return res;
        }

        virtual bool read(const string_t &filepath) = 0;

        virtual bool write(const string_t &filepath) const = 0;

    };
}


#endif //MIMIR_ABSTRACT_SELECTION_MODEL_H
