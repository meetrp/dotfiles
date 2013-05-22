#
# Copyright 2013 Rp (www.meetrp.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#       http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

def clone(s):
    # there are 2 other methods to create a copy of a list
    #   1. new_list = list(old_list)
    #   2. import copy
    #      new_list = copy.copy(old_list)
    return s[:]


def remove_duplicates(seq):
    # list of list can't be converted using set(), directly
    return [list(t) for t in set(tuple(x) for x in seq)]


def binary_insert(elem, seq):
    """
    find the position, using binary search, to insert 'elem' in the sequence
    """
    low = 0
    high = len(seq) - 1
    if high == low:
        seq[low] = elem
        return

    while (low < high):
        x = (low + high) / 2
        if (seq[x] < elem):
            low = x + 1
        else:
            high = x

    seq[low] = elem

    if low + 1 != len(seq):
        del(seq[(low + 1):])    # delete to the right after insert position
        return False            # inserted somewhere in between
    else:
        return True             # the last element was replaced


# Global variables
longest_subsequence = 0
last_elem_in_longest = 0

def inc_global_longest_subsequence():
    global longest_subsequence
    longest_subsequence += 1

def update_global_last_elem(elem):
    global last_elem_in_longest
    last_elem_in_longest = elem
    

def lis(elem, list_of_seq):
    """
    compare 'elem' against every subsequence in 'list_of_seq'
    depending on the subsequence either IGNORE, CLONE, DISCARD or EXTEND
    """
    len_of_list_of_seq = len(list_of_seq)
    for i in range(len_of_list_of_seq):
        seq = list_of_seq[i]
        if not seq:
            continue

        if seq[len(seq) - 1] < elem:
            seq.append(elem)
            if (longest_subsequence < len(seq)):
                inc_global_longest_subsequence()

                # there can be more than one longest susbsequence
                # and the last_elem_in_longest can point to the
                # other longest subsequence. In that case, don't update.
                if last_elem_in_longest < elem:
                    update_global_last_elem(elem)
        elif seq[len(seq) - 1] > elem:
            new_seq = clone(seq)
            if binary_insert(elem, new_seq) and \
                elem < last_elem_in_longest:
                update_global_last_elem(elem)

            list_of_seq.append(new_seq)

    list_of_seq = remove_duplicates(list_of_seq)

    # prepare a list of to-be-deleted subsequences, which cannot
    # become the LIS
    to_be_del = []
    len_of_list_of_seq = len(list_of_seq)
    for i in range(len_of_list_of_seq):
        seq = list_of_seq[i]
        if not seq:
            to_be_del.append(i)     # empty subsequences!!
            continue

        # delete any subsequence smaller in length than the (current)
        # longest yet its last element is greater than the last
        # element in the (current) longest subsequence
        if (len(seq) < longest_subsequence) and \
            (seq[len(seq) - 1] >= last_elem_in_longest):
            to_be_del.append(i)

    for i in reversed(to_be_del):
        del(list_of_seq[i])

    return list_of_seq

def main():
    seq = [0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15]
    #seq = [2, 5, 3, 7, 11, 8, 10, 13, 6 ]
    #seq = [10, 22, 9, 33, 21, 50, 41, 60, 80]

    list_of_seq = list()    # store the list of subsequences
    for x in (seq):
        if not list_of_seq:
            list_of_seq.append([x])
            inc_global_longest_subsequence()
            continue

        list_of_seq = lis(x, list_of_seq)

    print "Original Seq: ", seq
    print "Least Increasing Subsequence Count: ", longest_subsequence
    for sub_seq in list_of_seq:
        if len(sub_seq) < longest_subsequence:
            continue
        print sub_seq

if __name__ == "__main__":
    """
    Given an array of random numbers. Find longest monotonically increasing
    subsequence (LIS) in the array.
     - http://en.wikipedia.org/wiki/Longest_increasing_subsequence
     - http://www.geeksforgeeks.org/longest-monotonically-increasing-subsequence-size-n-log-n/
    """
    main()
